class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :current_user

  def index
  end

  protected

  def current_user
    @user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render_json_collection(collection, options={})
    render({json: collection, serializer: PaginatedSerializer}.merge(options))
  end
end
