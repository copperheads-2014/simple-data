class HeadersController < ApplicationController

  def index
    @version = Version.find(params[:version_id])
    @headers = @version.headers
  end

  def create
    @version = Version.find(params[:version_id])
    @headers = @version.headers
    @headers.each_with_index do |header, i|
      header.update(description: params[:headers][i][:description],
                    data_type: params[:headers][i][:data_type])
    end
    redirect_to "/versions/#{@version.id}"
  end

end
