class RecordsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    @records = @service.records
    if params[:offset] && params[:limit]
      render json: @records.skip(params[:offset]).limit(params[:limit])
    elsif params[:sortby] && params[:order]
      render json: @records.order_by(params[:sortby] + " " + params[:order])
    elsif params[:limit]
      render json: @records.limit(params[:limit])
    elsif params[:offset]
      render json: @records.skip(params[:offset])

    # elsif params[:filter]
    #   filter_headers = params[:filter]
    #   @records.pluck()
    else
      render json: @records
    end

  end

  # TO DO: Add in a controller option for the OPTIONS HTTP method.


end
