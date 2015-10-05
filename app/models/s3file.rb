class S3file < ActiveRecord::Base
  belongs_to :dealer
  belongs_to :dms_file
  has_many :sales
  has_many :services
  has_many :appointments

  validates :name, uniqueness: true

  before_save :find_and_set_dealer
  before_save :set_file_type

  def self.register_local_files
    Dir.glob('tmp/')
  end

  def download_file
    s3_config = AwsUtils.s3_config

    begin
      path = AwsUtils.file_download(s3_config["S3_BUCKET_INBOUND"], self.name)
    end

    if File.file?(path)
      return path
    else
      return false
    end
  end

  def set_file_type

    if /.*_SA.TXT/.match(self.name)
      self.file_type = "Appointment"
    elsif /.*_SV.TXT/.match(self.name)
      self.file_type = "Service"
    elsif /.*_SL.TXT/.match(self.name)
      self.file_type = "Sale"
    end
  end

  def find_and_set_dealer
    unless self.dealer_id.present? && self.dealer.is_a?(Dealer)
      starting = self.name.index('DFC')

      if starting && starting >= 0
        ending = starting + 6

        name_string = self.name[starting..ending]

        dealer = Dealer.where('dealer_focus_id LIKE ?', name_string).first

        if dealer && dealer.present?
          self.dealer_id = dealer.id
          self.status    = "registered"

          dealer.update(dms_data: true)
        else

          self.status = 'hold'
        end
      end
    end
  end

  def move_ons3

    bucket_from = AwsUtils.s3_config["S3_BUCKET_INBOUND"]
    bucket_to = AwsUtils.s3_config["S3_BUCKET_ARCHIVE"]

    if AwsUtils.move_buckets(self.name, bucket_from, bucket_to)

      self.update(status: 'moved')

      return true
    else

      return false
    end
  end
end
