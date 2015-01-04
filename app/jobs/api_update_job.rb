require 'csv'

class ApiUpdateJob < ActiveJob::Base
  queue_as :default

  def perform(service_id, current_user_id, params)
    #Get the file from S3
    uploaded_csv = new_retrieve_file(params[:file])
    #Insert the records as Mongo Documents as part of a Mongo Collection
    service = Service.find(service_id)
    service.create_records(uploaded_csv)
    service.set_total_records
    service.update(creator_id: current_user_id)
    # Find or create tags and add them to the service
    service.add_tags(params[:tags])
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
