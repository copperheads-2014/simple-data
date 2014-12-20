class RecordsController < ApplicationController
  def index
    @service = Service.find(params[:service_id])
    @records = @service.records
  end


end
