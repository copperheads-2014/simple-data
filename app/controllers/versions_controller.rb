class VersionsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
  end

  def show
    @service = Service.find_by(slug: params[:service_slug])
    @version = @service.versions.find_by(id: params[:version_id])
    @organization = Organization.find_by(id: @service.organization_id)
    @headers = @service.versions.find_by(id: 1).number
    # @headers << "sample"
    # @headers = @services.versions.find_by(id: params[:version_id]).headers.map(&:name)
  end
end
