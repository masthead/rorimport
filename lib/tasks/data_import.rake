task :data_import => :environment do
  start_time = Time.now

  DmsFile.list_new_files

  s3files = S3file.where(status: 'registered')

  file_count = s3files.count

  puts "file count is #{file_count}"

  s3files.each do |s3|
    DmsImport.import_file s3.id
  end

  puts "--------------------------- Results -------------------------------"
  puts "Imported #{file_count} files in #{Time.now - start_time} seconds"
  puts "--------------------------- Finished ------------------------------"

end