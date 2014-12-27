class PagesController < ApplicationController
  def about_us
    @page_title = "About Us"
  end

  def faqs
    @page_title = "Frequently Asked Questions"
  end

  def contact_us
    @page_title = "Contact Us"
  end
end
