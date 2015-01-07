class OrganizationsController < ApplicationController
  def index
    @organizations = Organization.paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html
      format.json { render_json_collection @organizations }
    end
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    respond_to do |format|
      if @organization.save
        current_user.update(organization_id: @organization.id)
        format.html { redirect_to new_service_path, notice: 'Organization was successfully created.' }
        format.json { render location: organization_path(@organization),  status: :created }
      else
        format.html { render :new }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @organization = Organization.includes(:services).find(params[:id])
    @services = @organization.services.paginate(:page => params[:page], :per_page => 5)
    respond_to do |format|
      format.html
      format.json { render json: @organization }
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :description)
  end
end
