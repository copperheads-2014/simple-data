require 'csv'
require 'openuri'

class CSVImport < ActiveJob::Base
  queue_as :default

  def perform(version_update_id, params={})
    version_update = VersionUpdate.find(version_update_id)
    version_update.update(status: :processing)
    # download the file locally
    file = download_file(version_update.filename)
    # parse the headers
    headers = CSV.foreach(file).first
    # create the headers schema
    create_header_schema(headers)
    # import the data
    version_update.version.create_records(file)
    # delete the file
    version_update.update(status: :completed)
  rescue => e
    version_update.update(status: :failed)
  end

  def download_file(filename)
    # download the file into tmp/
    # return the File object (do not open it)
  end

  def create_headers_schema(headers)
    # figure out what data structure you should store headers as
    # store them
  end
end
