class OrganizationsController < ApplicationController
  def new
    @organization = Organization.new
  end

  def create
  end

  def edit
  end

  def destroy
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
