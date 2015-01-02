class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    @records = RecordQueryService.new(@service, default_params.merge(params)).fetch_records
    render json: @records.to_json, status: 200
  end

  protected

  def default_params
    {limit: 50, offset: 0}.with_indifferent_access
  end
end
