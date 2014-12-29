class ServicesController < ApplicationController

  # shows all services available to use
  def index
    @services = Service.all
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    @service.organization_id = @user.organization.id
    if @service.save
      uploaded_csv = file_to_database(params[:service][:file])
      @service.create_records(uploaded_csv)
      @service.set_total_records
      redirect_to "/services/#{@service.slug}/records"
    end
  end

  def show
    @service = Service.find_by(slug: params[:service_slug])
  end

# only a member of the service's organization can edit or destroy the service
  def edit
    @service = Service.find_by(slug: params[:service_slug])
  end

  def update
    @service = Service.find_by(slug: params[:service_slug])
    if @service.save && (@service.organization_id == current_user.organization_id)
      update_csv = file_to_database(params[:service][:file])
      if headers_match?(update_csv, @service)
        @service.create_records(update_csv)
        @service.set_total_records
        redirect_to "/services/#{@service.slug}/records"
      else
        redirect_to "/services/#{@service.slug}/edit"
        p "headers don't match"
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

end
