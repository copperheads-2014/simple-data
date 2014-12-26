module ApplicationHelper
  def page_title
    base_title = "Simple Data"
    if @page_title.nil?
      "#{params[:controller].capitalize} - #{params[:action].capitalize} | " + base_title
    else
      "#{@page_title} | #{base_title}"
    end
  end
end

