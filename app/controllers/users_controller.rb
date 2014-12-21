class UsersController < ApplicationController
  def create
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
  end

  private

  def user_params
    params.require(:users).permit(:name, :email, :password, :password_confirmation)
  end
end
