require 'csv'
require 'open-uri'
require 'fileutils'

class CsvImportJob < ActiveJob::Base
  queue_as :default

  ROOT_CSV_PATH="#{Rails.root.to_s}/tmp/csv/"

  def perform(version_update_id, update_params = {updating: false, append: false, new_version: false}, params={} )
    @version_update = VersionUpdate.find(version_update_id)
    @version_update.update(status: :processing)
    FileUtils.mkdir_p ROOT_CSV_PATH
    @csv_path = "#{ROOT_CSV_PATH}/#{friendly_filename(@version_update.version.service.slug)}.csv"

    if update_params[:updating]
      p "HERE WE ARE UPDATING!!!!!!!!!!!!!!!!!!!!"
      append_with_same_headers if update_params[:append]
      create_new_version if update_params[:new_version]
    else
      p "HERE WE ARE CREATING!!!!!!!!!!!!!!!!!!!!"
      create_first_version
    end
  end

  def friendly_filename(filename)
    filename.gsub(/[^\w\s_-]+/, '')
            .gsub(/(^|\b\s)\s+($|\s?\b)/, '\\1\\2')
            .gsub(/\s+/, '_')
  end

  def create_first_version
    p "HERE WE ARE CREATING THE FIRST VERSION WITH HEADERS!!!!!!!!!!!!!!!!!!!!"
    @version_update.update(status: :processing)
    download_and_add_records_and_set_headers
  end

  def append_with_same_headers
    p "HERE WE ARE APPENDING AN API!!!!!!!!!!!!!!!!!!!!"
    download_and_add_records_and_set_headers
  end

  def create_new_version
    p "HERE WE ARE CREATING A NEW VERSION WITH HEADERS!!!!!!!!!!!!!!!!!!!!!!!"
    download_file(@version_update.filename)
    file = open(@csv_path)
    service_to_update = @version_update.version.service
    current_version = @version_update.version

    new_version = Version.new(number: current_version.number + 1)
    service_to_update.versions << new_version
    new_version.make_version_update(@version_update.filename)

    add_records(file, new_version.id)

    headers = grab_headers(file)
    create_headers_schema(headers, new_version.updates.last)

  end

  def download_and_add_records_and_set_headers
    # download the file locally
    download_file(@version_update.filename)
    file = open(@csv_path)
    # import the data
    add_records(file, @version_update.version.id)
    # parse the headers
    headers = grab_headers(file)
    # create the headers schema
    create_headers_schema(headers, @version_update) if @version_update.version.headers.empty?
    @version_update.update(status: :completed)
  end

  def download_file(filename)
    File.open(@csv_path, "wb") do |file|
      file.write open(filename).read
    end
  end

  def grab_headers(file)
    CSV.readlines(file).first
  end

  def create_headers_schema(headers, version_update)
    version_update.version.headers = headers.map { |name| Header.create(name: name) }
    version_update.version.save!
  end

  def add_records(file, version_id)
    version = Version.find(version_id)
    last_count = version.total_records
    CSV.foreach(file, headers: true) do |row|
      row_hash = row.to_hash
      row_hash[:insertion_id] = last_count += 1
      version.insert_record(row_hash)
    end
    version.set_total_records
  end

end
