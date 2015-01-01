class ServicesController < ApplicationController

  # shows all services available to use
  def index
    @my_services = current_user.organization.services
    @other_services = Service.all - @my_services
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
      uploaded_csv = file_to_database(params[:service][:file])
      @service.create_records(uploaded_csv)
      @service.set_total_records
      delete_original_file(params[:service][:file])
      redirect_to "/services/#{@service.slug}/set_headers.html.haml"
    end
  end

  def set_headers
    set_service
    render "set_headers.html.haml", :layout => false

  def documentation
    set_service
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
    if @service.save && (@service.organization_id == current_user.organization_id)
      update_csv = file_to_database(params[:service][:file])
      if headers_match?(update_csv, @service)
        @service.create_records(update_csv)
        @service.set_total_records
        delete_original_file(params[:service][:file])
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

  def file_to_database(params)
    # Load the CSV into the repository in public/uploads
    uploaded_io = params
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
    #Take loaded CSV and write it to database
    CSV.read(Rails.root.join('public', 'uploads', uploaded_io.original_filename),
      headers: true,
      :converters => :all,
      :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? } )
  end

  def headers_match?(new_file, existing_doc)
    # to make sure file headers match what's in the database
    existing_headers = existing_doc.records.first.attributes.keys
    existing_headers.shift
    new_file.headers.sort == existing_headers.sort
  end

  def delete_original_file(params)
    # Delete file from the public folder after its data has been saved to database
    File.delete(Rails.root.join('public', 'uploads', params.original_filename))
  end

  def set_service
    @service ||= Service.find_by(slug: params[:service_slug])
  end
end
