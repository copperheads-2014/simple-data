class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    @records = @service.records
    render json: @records
  end


end
