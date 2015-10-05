class DmsFile < ActiveRecord::Base
  has_many :s3files

  def self.list_new_files

    if Rails.env.production?
      s3_config = AwsUtils.s3_config

      require 'net/ftp'

      original_bucket = s3_config["S3_BUCKET_ORIGINAL"]

      directories = ["/Polling Processing/History Files/", "/Polling Processing/Sample Files/", "/Polling Processing/Daily Files/" ]

      #ftp stuff
      ftp = Net::FTP.new("ftp.authenticom.net")
      ftp.passive = true
      ftp.login(s3_config["ACOM_FTP_USER"], s3_config["ACOM_FTP_PASS"])

      directories.each do |directory|

        ftp.chdir(directory)

        puts "listing files in #{directory}"
        files = ftp.nlst()

        files.each do |file|

          import_file = DmsFile.where(name: file, ftp_directory: directory).first_or_create

          if import_file && import_file.s3path.present?
            next
          else
            ftp.getbinaryfile(import_file.name, import_file.local_file_path)

            AwsUtils.file_upload(original_bucket, import_file.local_file_path)

            DmsFileWorker.perform_async(import_file.id)
          end
        end
      end
    else

      Dir.glob("tmp/*.txt").each do |listing|

        file = File.basename(listing)

        import_file = DmsFile.where(name: file).first_or_create

        import_file.s3files.where(name: file).first_or_create
      end
    end
  end

  def local_file_path
    "tmp/#{name}"
  end

  def get_file_from_ftp

    s3_config = AwsUtils.s3_config

    #ftp stuff
    require 'net/ftp'

    ftp = Net::FTP.new("ftp.authenticom.net")
    ftp.passive = true
    ftp.login(s3_config["ACOM_FTP_USER"], s3_config["ACOM_FTP_PASS"])

    original_bucket = s3_config["S3_BUCKET_ORIGINAL"]

    ftp.chdir(ftp_directory)

    ftp.getbinaryfile(name, local_file_path)

    if File.file?(local_file_path) && AwsUtils.file_upload(original_bucket, local_file_path)

      update(s3path: "http://s3.amazonaws.com/#{original_bucket}/#{name}")

      split_to_s3
    end
  end

  def split_to_s3

    s3_config = AwsUtils.s3_config

    if File.file?(local_file_path)
      file_path = local_file_path
    else
      file_path = AwsUtils.file_download(s3_config["S3_BUCKET_ORIGINAL"], name)
    end

    bucket = s3_config["S3_BUCKET_INBOUND"]

    max_output_lines = 500

    n = 0

    ifile = File.open(file_path,"r")

    header = ifile.gets

    until(ifile.eof?)
      new_file_name = "tmp/partial_#{n}_#{File.basename(file_path)}"
      ofn = sprintf(new_file_name,n)
      ofile = File.open(ofn,"w")
      ofile.write(header)
      line = 2
      until(ifile.eof? || line > max_output_lines)
        ofile.write(ifile.gets)
        line += 1
      end

      ofile.close

      s3_file = s3files.where(name: File.basename(new_file_name)).first_or_create(size: File.size(new_file_name), status: 'registered')

      if s3_file && s3_file.is_a?(S3file)
        DmsImportWorker.perform_async(s3_file.id)
      end

      AwsUtils.file_upload(bucket, new_file_name)
      n += 1
    end

    ifile.close
  end
end
