class ServicesController < ApplicationController

  # shows all services available to use
  def index
    @services = Service.all
  end

  def new
  end

  def create
  end

  def show
    @service = Service.find(params[:id])
  end

# only the creator of the service can edit or destroy
  def edit
  end

  def update

  end

  def destroy
  end
end
