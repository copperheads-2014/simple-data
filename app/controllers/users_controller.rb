class UsersController < ApplicationController
  def create
    @user = User.new(user_params)

    respond_to do |t|
      if @user.save
      else
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
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
