require 'csv'
require 'open-uri'

class CsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(version_update_id, params={})
    @version_update = VersionUpdate.find(version_update_id)
    @version_update.update(status: :processing)
    # download the file locally
    file = download_file(@version_update.filename)
    # parse the headers
    headers = grab_headers(file)
    # create the headers schema
    create_header_schema(headers)
    # import the data
    @version_update.version.create_records(file)
    # delete the file
    @version_update.update(status: :completed)
  rescue => e
    @version_update.update(status: :failed)
  end

  def download_file(filename)
    file = open(filename)
    return file
    # return the File object (do not open it)
  end

  def grab_headers(file)
    headers = []
    CSV.foreach(file) {|row| headers << row; break; }
    return headers
  end

  def create_headers_schema(headers)
    headers.each do |header_name|
      @version_update.version.headers << Header.create(name: header_name)
    end
  end

  def create_records(file, version_id)
    version = Version.find(version_id)
    last_count = version.total_records
    CSV.new(file, headers: true, header_converters: lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
      ).each do |row|
      row_hash = row.to_hash
      row_hash[:insertion_id] = last_count += 1
      version.insert_record(row_hash)
    end
  end

end
