require 'rails_helper'

feature "Browsing the website" do
  scenario "User visits the landing page" do
    visit '/'
    expect(page).to have_text("Give us your data")
  end

  scenario "User clicks get started button and is redirected to account creation page" do
    visit '/'
    click_link "Create API"
    expect(page).to have_text("Confirm Password")
  end

  scenario "User can visit the 'About Us' page" do
    visit '/'
    click_link "About Us"
    expect(page.current_path).to eq("/about_us")
  end

  scenario "User can visit the 'Contact Us' page" do
    visit '/'
    click_link "Contact Us"
    expect(page.current_path).to eq("/contact_us")
  end

  scenario "User can visit the FAQs page" do
    visit '/'
    click_link "FAQs"
    expect(page.current_path).to eq("/faqs")
  end

end

feature "Signing in" do
  background do
    User.create(name: "TheGreek", email: "Plato@athens.gr", organization_id: 1, password: 'password', password_confirmation: 'password')
  end

  scenario "Signing in with the correct credentials" do
    visit "/sessions/new"

    page.fill_in "session_email", with: "Plato@athens.gr"
    page.fill_in "session_password", with: "password"
    click_button "Login"

    expect(page.current_path).to eq("/services/new")
  end

  scenario "Signing in with incorrect credentials" do
    visit "/sessions/new"

    page.fill_in "session_email", with: "Trojanscum@gmail.com"
    page.fill_in "session_password", with: "Whatchulookinat"
    click_button "Login"

    expect(page).to have_text("Create a New User")
  end
end

feature "Creating an account" do
end

feature "Uploading an API" do
end

feature "Retrieving data from API endpoints" do
end



