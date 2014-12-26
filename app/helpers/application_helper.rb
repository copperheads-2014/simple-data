module ApplicationHelper
  def page_title
    base_title = "Simple Data"
    if @page_title.nil?
      "#{params[:controller].capitalize} - #{params[:action].capitalize} | " + base_title
    else
      "#{@page_title} | #{base_title}"
    end
  end

  def current_user
    @_current_user ||= User.find(session[:user_id])
  end

  def current_org
    @_current_org ||= Organization.find(current_user.organization_id)
  end
end

