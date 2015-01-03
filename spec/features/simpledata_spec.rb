require 'rails_helper'

feature "User visits the website" do
  scenario "User visits the landing page" do
    visit '/'
    expect(page).to have_text("Give us your data")
  end

  scenario "User clicks get started button and is redirected to account creation page" do
    visit '/'
    click_link "Get Started"
    expect(page).to have_text("Confirm Password")
  end

  scenario "User can visit the 'About Us' page" do
    visit '/'
    click_link "About Us"
    expect(page.current_path).to eq("/about_us")
  end



end

