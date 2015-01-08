'will_paginate/array'

class UsersController < ApplicationController
  skip_before_action :current_user

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to new_service_path, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html {render :new}
      end
    end
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.organization
      @organization = @user.organization
    end
    @log = activity_log(@user).paginate(:page => params[:page])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def activity_log(user)
    collect_logs(user)
  end

  def collect_logs(user)
    collection = []
    services = Service.where(creator_id: user.id).to_a
    updates = VersionUpdate.where(user_id: user.id).to_a
    collection << services
    collection << updates
    collection.flatten!
    sort_collection(collection)
  end

  def sort_collection(collection)
    @log = collection[0..-1].sort_by { |item| item.created_at }
  end
end
