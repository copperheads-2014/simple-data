require 'csv'

class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(service_id, current_user_id, old_record_count, params)
    #Get the file from S3
    update_csv = new_retrieve_file(params[:file]).read
    #Insert the records as Mongo Documents as part of a Mongo Collection
    service = Service.find(service_id)
    service.create_records(update_csv)
    service.set_total_records

    # We are creating an update record here.
    update = ServiceUpdate.create!(service_id: service.id, user_id: current_user_id)
    update.set_records_added(old_record_count, service.records.count)
  end

  def new_retrieve_file(params)
    file = open(params).read
    CSV.new(file,
      headers: true,
      :converters => :all,
      :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
      )
  end

end
