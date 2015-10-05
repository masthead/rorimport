require 'aws-sdk'
require 'open-uri'

class AwsUtils

  def self.s3_config #this works since V2 upgrade
    YAML.load_file(Rails.root+"config/application.yml")[Rails.env]
  end

  def self.s3_object #this works since v2 update

    @s3_config = AwsUtils.s3_config

    puts "AWS S3 Initializing"
    @s3 = Aws::S3::Client.new(
        :access_key_id      => @s3_config["S3_ACCESS_KEY_ID"],
        :secret_access_key  => @s3_config["S3_SECRET_ACCESS_KEY"],
        :region => 'us-east-1'
    )
  end

  def self.list_files(bucket) #this works since v2 update
    AwsUtils.s3_object.list_objects(bucket: bucket)
  end

  def self.list_files_array(bucket)

    files = []

    list_files(bucket).contents.each do |object|
      files << object.key
    end

    files
  end

  def self.file_upload(bucket_name, handle) #this works since v2 update

    @s3 = s3_object

    begin
      key = File.basename(handle)
      resp = @s3.put_object(:bucket => bucket_name, :key => key, :body => IO.read(handle), :acl => 'public-read')

      return "https://s3.amazonaws.com/#{bucket_name}/#{key}"
    rescue Exception => e
    end
  end

  def self.file_download(bucket, key, filename = nil) #this works since v2 update

    @s3 = s3_object

    unless filename
      filename = "tmp/#{key}"
    end

    resp = @s3.get_object({ bucket: bucket, key: key }, target: filename)

    if resp && File.file?(filename)
      return filename
    else
      return false
    end
  end

  def self.file_delete(bucket, key) #works on v2
    @s3 = AwsUtils.s3_object

    if @s3.delete_object(bucket: bucket, key: key)
      return true
    else
      return false
    end
  end

  def self.move_buckets(key, original_bucket, new_bucket)# works since new update v2

    success = false

    if file_download(original_bucket, key)
      if file_upload(new_bucket, "tmp/#{key}")
        if file_delete(original_bucket, key)
          puts "File #{key} moved and deleted"
          success =  true
        end
      end
    end

    success
  end
end