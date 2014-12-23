class ServicesController < ApplicationController

  # shows all services available to use
  def index
    @services = Service.all
  end

  def new
    @service = Service.new
  end

  def create
    uploaded_io = params[:file]
    File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'wb') do |file|
    file.write(uploaded_io.read)
    end
    uploaded_csv = CSV.read(Rails.root.join('public', 'uploads', uploaded_io.original_filename), headers: true)
    uploaded_csv.each do |row|
      Service.last.records.create(row.to_hash)
    end
  end

  def show
    # @service = Service.find(params[:id])
    @service = Service.find_by(slug: params[:service_slug])
  end

# only the creator of the service can edit or destroy
  def edit
  end

  def update

  end

  def destroy
  end
end
