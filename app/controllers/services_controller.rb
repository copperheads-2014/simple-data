require "open-uri"
require 'csv'

class ServicesController < ApplicationController

  # shows all services available to use
  def index
    if current_user && current_user.organization
      @my_services = current_user.organization.services
    end
    @services = Service.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    if current_user && current_user.organization
      @service = Service.new()
    else
      redirect_to "/organizations/new"
    end
  end

  def form
    @service = Service.new
    render "_form.html.haml", :layout => false
  end

  def create
    @service = ServiceCreation.create(service_params, current_user)
    @service.organization_id = current_user.organization.id
    @service.versions.last.updates << VersionUpdate.create(filename: params[:service][:file])
    @service.save
    CsvImportJob.perform_later(@service.latest_version.updates.last.id, params[:service])
    #Redirect to pending view
    redirect_to "/services"
  end

  def set_headers
    set_service
    render "set_headers.html.haml", :layout => false
  end

  def documentation
    set_service
    @headers = get_headers(@service)
  end

  def show_header_metadata
    @service = Service.find_by(slug: params[:service_slug])
    render json: @service.header_metadatas, status: 200
  end

  def show
    @service = Service.find_by(slug: params[:service_slug])
    @organization = Organization.find_by_id(@service.organization_id)
    @headers = @service.show_headers
  end

# only a member of the service's organization can edit or destroy the service
  def edit
    set_service
  end

  def update
    @service = Service.find_by(slug: params[:service_slug])
    respond_to do |format|

      #Ensure the individual submitting owns the organization
      if @service.save && (@service.organization_id == current_user.organization_id)
        #Read in the posted file from S3
        update_csv = retrieve_file(params[:service][:file]).read
        if headers_match?(update_csv, @service)
          old_record_count = @service.records.count
          ApiUpdateJob.perform_later(@service.id, current_user.id, old_record_count, params[:service])
          format.html { redirect_to "/services/#{@service.slug}", notice: "Service was successfully updated."}
          else
          format.html { redirect_to "/services/#{@service.slug}/edit"}
        end
      end
    end
  end

  def deactivate
    @service = Service.find_by(slug: params[:service_slug])
    @service.deactivate if @service.organization_id == current_user.organization_id
    redirect_to "/services/#{@service.slug}"
  end

  def activate
    @service = Service.find_by(slug: params[:service_slug])
    @service.activate if @service.organization_id == current_user.organization_id
    redirect_to "/services/#{@service.slug}"
  end

  private

  def retrieve_file(params)
    file = open(params).read
    CSV.new(file,
      headers: true,
      :converters => :all,
      :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
      )
  end

  def service_params
    params.require(:service).permit(:description, :name)
  end

  def headers_match?(new_file, existing_doc)
    existing_headers = existing_doc.show_headers
    new_file.headers.sort == existing_headers.sort
  end

  def get_headers(service)
    service.records.first.attributes.keys
  end

  def set_service
    @service ||= Service.find_by(slug: params[:service_slug])
  end

end


