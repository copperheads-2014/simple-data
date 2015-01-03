require "open-uri"
class ServicesController < ApplicationController

  # shows all services available to use
  def index
    if current_user
      @my_services = current_user.organization.services
    end
    @services = Service.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @service = Service.new()
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @service }
    end
  end

  def form
    @service = Service.new
    render "_form.html.haml", :layout => false
  end

  def create
    @service = Service.new(service_params)
    @service.organization_id = @user.organization.id
    if @service.save
      uploaded_csv = retrieve_file(params[:service][:file])
      @service.create_records(uploaded_csv)
      @service.set_total_records
      redirect_to "/services/#{@service.slug}/set_headers.html.haml"
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
  end

# only a member of the service's organization can edit or destroy the service
  def edit
    set_service
  end

  def update
    @service = Service.find_by(slug: params[:service_slug])
    #Ensure the individual submitting owns the organization
    if @service.save && (@service.organization_id == current_user.organization_id)
      #Read in the posted file from S3
      update_csv = retrieve_file(params[:service][:file]).read
      if headers_match?(update_csv, @service)
        @service.create_records(update_csv)
        @service.set_total_records
        redirect_to "/services/#{@service.slug}/records"
      else
        redirect_to "/services/#{@service.slug}/edit"
      end
    end
  end

  def destroy
  end

  private

  def service_params
    params.require(:service).permit(:description, :name)
  end

  def retrieve_file(params)
    file = open(params).read
    CSV.new(file,
      headers: true,
      :converters => :all,
      :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
      )
  end

  def headers_match?(new_file, existing_doc)
    # to make sure file headers match what's in the database
    existing_headers = existing_doc.records.first.attributes.keys
    existing_headers.shift
    new_file.headers.sort == existing_headers.sort
  end

  def get_headers(service)
    service.records.first.attributes.keys
  end

  def set_service
    @service ||= Service.find_by(slug: params[:service_slug])
  end
end
