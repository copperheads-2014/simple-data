class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    v_num = params[:version][1..-1]
    @version = @service.versions.find_by(number: v_num)
    if @service.activated && @version.active
      @records = RecordQueryService.new(@service, default_params.merge(params)).fetch_records
      @formatter = DataFormatter.new(start: params[:start], data: @records.to_json(json_options))
      render json: @formatter.to_json(except: ["created_at","updated_at","id"]), status: 200
    else
      render json: "This service has been deactivated. Check the service's documentation for details."
    end
  end

  protected

  def default_params
    {page_size: 50, start: 0, sortby: :insertion_id, order: :asc}.with_indifferent_access
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
