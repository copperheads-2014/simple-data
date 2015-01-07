class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.paginate(:page => params[:page], :per_page => 10)
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = current_user.organizations.new(organization_params)
    respond_to do |format|
      if @organization.save
        format.html {redirect_to services_new_path, notice: 'Organization was successfully created.' }
      else
        format.html {render :new}
      end
    end
  end

  def show
    @organization = Organization.find(params[:id])
    @services = Service.where(organization: @organization.id).paginate(:page => params[:page], :per_page => 5)
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
