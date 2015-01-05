class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    if @service.activated
      @records = RecordQueryService.new(@service, default_params.merge(params)).fetch_records
      render json: @records.to_json(json_options), status: 200
    else
      render json: "This service has been deactivated. Check the service's documentation for details."
    end
  end

  protected

  def default_params
    {limit: 50, offset: 0, sortby: :insertion_id, order: :asc}.with_indifferent_access
  end

  def default_options
    @options = {except: "_id"}
  end

  def json_options
    default_options
    if params[:only]
      @options[:only] = params[:only].split(",")
    end
    @options
  end

end
