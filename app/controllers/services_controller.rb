class ServicesController < ApplicationController

  # shows all services available to use
  def index
    @services = Service.all
  end

  def new
    @service = Service.new
  end

  def create
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
