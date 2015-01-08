require "open-uri"
require 'csv'

class ServicesController < ApplicationController

  # shows all services available to use
  def index
    if current_user && current_user.organization
      @my_services = current_user.organization.services.paginate(:page => params[:page])
    end
    @services = Service.paginate(:page => params[:page])
    respond_to do |format|
      format.html
      format.json { render_json_collection @services }
    end
  end

  def new
    if current_user && current_user.organization
      @service = Service.new()
    elsif current_user
      redirect_to new_organization_path
    else
      redirect_to new_user_path
    end
  end

  def form
    @service = Service.new
    render "_form.html.haml", :layout => false
  end

  def create
    update_params = {}
    @service = Service.new(service_params)
    # @service = ServiceCreation.new(service_params, current_user)
    @service.organization = current_user.organization
    if @service.save # Saving a service automatically creates a new version with a callback.
      @service.versions.last.updates << VersionUpdate.create(filename: params[:service][:file])
      CsvImportJob.perform_later(@service.latest_version.updates.last.id, update_params, params[:service])
      #Redirect to pending view
      redirect_to "/services/#{@service.slug}"
    else
      render :new
    end
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
    respond_to do |format|
      format.html
      format.json { render json: @service }
    end
  end

# only a member of the service's organization can edit or destroy the service
  def edit
    set_service
    @headers = @service.latest_version.headers
  end

  def update
    @service = Service.find_by(slug: params[:service_slug])
    respond_to do |format|
      #Ensure the individual submitting owns the organization
      if @service && (@service.organization_id == current_user.organization_id)
        if params[:service][:append].to_bool
          p "SERVICE CHECK PASSED"
          update_csv = retrieve_file(params[:service][:file]).read
          p "CSV HEADERS CHECK PASSED"
          if headers_match?(update_csv, @service)
            p "JOB ABOUT TO START"
            CsvImportJob.perform_later(@service.latest_version.updates.last.id,
                                      {updating: params[:service][:updating].to_bool,
                                       append: params[:service][:append].to_bool,
                                       new_version: params[:service][:new_version].to_bool },
                                       params[:service])
            format.html { redirect_to "/services/#{@service.slug}", notice: "Service was successfully updated."}
          else
            format.html { redirect_to "/services/#{@service.slug}/edit", notice: "The headers of your CSV file must match the example headers below. Either select that you want to create a new version, or edit your file so its headers match the headers of the current version."}
          end
        else
          @service.versions.last.updates << VersionUpdate.create(filename: params[:service][:file])
          CsvImportJob.perform_later(@service.latest_version.updates.last.id,
                                    {   updating: params[:service][:updating].to_bool,
                                        append: params[:service][:append].to_bool,
                                        new_version: params[:service][:new_version].to_bool },
                                      params[:service])
          format.html { redirect_to "/services/#{@service.slug}", notice: "New version was successfully created."}
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
      headers: true
      )
  end

  def service_params
    params.require(:service).permit(:description, :name)
  end

  def headers_match?(new_file, service)
    existing_headers = service.latest_version.headers.map { |header| header.name.downcase }
    new_file_headers = new_file.headers.map {|header| header.downcase }
    p existing_headers
    p new_file_headers
    new_file_headers.sort == existing_headers.sort
  end

  def get_headers(service)
    service.records.first.attributes.keys
  end

  def set_service
    @service ||= Service.find_by(slug: params[:service_slug])
  end

end


