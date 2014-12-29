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

      # Load the CSV into the repository in public/uploads
      uploaded_io = params[:service][:file]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      end
      #Take loaded CSV and write it to database
      uploaded_csv = CSV.read(Rails.root.join('public', 'uploads', uploaded_io.original_filename),
        headers: true,
        :converters => :all,
        :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? } )
      uploaded_csv.each do |row|
        @service.records.create(row.to_hash)
      end
      @service.set_total_records
      redirect_to "/services/#{@service.slug}/records"
    end
  end

  def show
    @service = Service.find_by(slug: params[:service_slug])
  end

# only the creator of the service can edit or destroy
  def edit
    @service = Service.find_by(slug: params[:service_slug])
  end

  def update
    @service = Service.find_by(slug: params[:service_slug])
    if @service.save && (@service.organization_id == current_user.organization_id)
      # Load the CSV into the repository in public/uploads
      uploaded_io = params[:service][:file]
      File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
      file.write(uploaded_io.read)
      end
      #Take loaded CSV and write it to database
      update_csv = CSV.read(Rails.root.join('public', 'uploads', uploaded_io.original_filename),
        headers: true,
        :converters => :all,
        :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? } )

      # check here to make sure file headers match what's in the database
      existing_headers = @service.records.first.attributes.keys
      existing_headers.shift
      if update_csv.headers.sort == existing_headers.sort
        # create new records in service doc
        update_csv.each { |row| @service.records.create(row.to_hash) }
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
end
