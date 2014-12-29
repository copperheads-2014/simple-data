class OrganizationsController < ApplicationController

  def index

  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    respond_to do |format|
      if @organization.save
        @user = User.find(session[:user_id])
        @user.update(organization_id: @organization.id)
        format.html {redirect_to services_new_path, notice: 'Organization was successfully created.' }
      else
        format.html {render :new}
      end
    end
  end

  def show
    @organization = Organization.find(params[:id])
    @services = @organization.services
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
