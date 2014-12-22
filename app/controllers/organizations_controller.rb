class OrganizationsController < ApplicationController
  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      @user = User.find(session[:user_id])
      @user.update(organization_id: @organization.id)
      redirect_to root_path
    else
    end
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
