class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    @records = @service.records
    if params[:limit]
      render json: @records.limit(params[:limit])
    # elsif params[:offset]
    #   render json: @records.something
    elsif params[:filter]
      @filtered_records = []
      @records.each do |record|

      end


    else
      render json: @records
    end

  end

  # TO DO: Add in a controller option for the OPTIONS HTTP method.


end
