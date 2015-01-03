class SessionsController < ApplicationController
  skip_before_action :current_user


  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      binding.pry
      session[:user_id] = @user.id
      redirect_to services_new_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to new_session_path
  end
end
