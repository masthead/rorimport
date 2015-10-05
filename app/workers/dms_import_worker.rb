class DmsImportWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :dms_import

  def perform(s3_file_id)
    s3_file = S3file.find s3_file_id

    if s3_file && s3_file.is_a?(S3file)
      DmsImport.import_file(s3_file_id)
    end
  end
end