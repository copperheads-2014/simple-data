module ApplicationHelper
  def page_title
    base_title = "Simple Data"
    if @page_title.nil?
      base_title
    else
      "#{@page_title}  | #{base_title}"
    end
  end
end

