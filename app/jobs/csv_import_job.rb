require 'csv'
require 'open-uri'

class CsvImportJob < ActiveJob::Base
  queue_as :default

  def perform(version_update_id, update_params = {updating: false, append: false, new_version: false}, params={} )
    @version_update = VersionUpdate.find(version_update_id)
    @version_update.update(status: :processing)

    p update_params
    if update_params[:updating]
      p "HERE WE ARE UPDATING!!!!!!!!!!!!!!!!!!!!"
      append_with_same_headers if update_params[:append]
      # maybe write a method: replace_with_same_headers
      create_new_version if update_params[:new_version]
    else
      p "HERE WE ARE CREATING!!!!!!!!!!!!!!!!!!!!"
      create_first_version
    end

  end

  def create_first_version
    p "HERE WE ARE CREATING THE FIRST VERSION WITH HEADERS!!!!!!!!!!!!!!!!!!!!"
    @version_update.update(status: :processing)
    download_and_add_records_and_set_headers
    # rescue => e
    #   @version_update.update(status: :failed)
  end

  def append_with_same_headers
    p "HERE WE ARE APPENDING AN API!!!!!!!!!!!!!!!!!!!!"
    download_and_add_records_and_set_headers
    #refactor this later
  end

  def create_new_version
    p "HERE WE ARE CREATING A NEW VERSION WITH HEADERS!!!!!!!!!!!!!!!!!!!!!!!"
    file = download_file(@version_update.filename)
    service_to_update = @version_update.version.service
    current_version = @version_update.version

    new_version = Version.new(number: current_version.number + 1)
    service_to_update.versions << new_version
    new_version.make_version_update(@version_update.filename)

    headers = grab_headers(file)
    create_headers_schema(headers, new_version.updates.last)

    add_records(file, new_version.id)
  end

  def download_and_add_records_and_set_headers
    # download the file locally
    file = download_file(@version_update.filename)
    # import the data
    add_records(file, @version_update.version.id)
    # parse the headers
    headers = grab_headers(file)
    # create the headers schema
    create_headers_schema(headers, @version_update) if @version_update.version.headers.empty?
    # delete the file
    @version_update.update(status: :completed)
  end

  def download_file(filename)
    file = open(filename).read
    # return the File object (do not open it)
  end

  def grab_headers(file)
    headers = []
    CSV.parse(file) {|row| headers << row; break; }
    headers.flatten!
    return headers
  end

  def create_headers_schema(headers, version_update)
    p headers
    headers.each do |header_name|
      version_update.version.headers << Header.create(name: header_name)
    end
  end

  def add_records(file, version_id)
    version = Version.find(version_id)
    last_count = version.total_records
    CSV.new(file, headers: true, header_converters: lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
      ).each do |row|
      row_hash = row.to_hash
      row_hash[:insertion_id] = last_count += 1
      version.insert_record(row_hash)
    end
    version.set_total_records
  end

end
