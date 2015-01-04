require 'rails_helper'

feature "Browsing the website" do
  scenario "User visits the landing page" do
    visit '/'
    expect(page).to have_text("Give us your data")
  end

  scenario "User clicks get started button and is redirected to account creation page" do
    visit '/'
    click_link "Create Account"
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

  scenario "Logged out user can browse APIs" do
    visit '/'
    click_link "Explore APIs"
    expect(page.current_path).to eq("/services")
  end

  scenario "Logged in user can browse APIs" do
    greek = User.new(name: "TheGreek", email: "Plato@athens.gr", password: 'password', password_confirmation: 'password')
    delian = Organization.create(name: "Delian League", description: "A buncha Greeks")
    zoos = Service.create(name: "Map of Zoos", description: "Description")
    delian.users << greek
    delian.services << zoos

    visit "/sessions/new"

    page.fill_in "session_email", with: "Plato@athens.gr"
    page.fill_in "session_password", with: "password"
    click_button "Login"

    click_link "simple-data"
    click_link "Explore APIs"
    expect(page).to have_text("Your Organization's APIs:")
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

    page.fill_in "session_email", with: "Socrates@gmail.com"
    page.fill_in "session_password", with: "Whatchulookinat"
    click_button "Login"

    expect(page).to have_text("Create a New User")
  end
end

feature "Creating an account" do
  scenario 'Visiting the new account page and creating a user account' do
    visit "/"
    click_link "Create Account"
    page.fill_in "user_name", with: "US Grant"
    page.fill_in "user_email", with: "OG_Gettysburg@whitehouse.gov"
    page.fill_in "user_password", with: "TheNorth"
    page.fill_in "user_password_confirmation", with: "TheNorth"
    click_button "Submit"

    expect(page.current_path).to eq("/services/new")
  end

  scenario "User tries to create an account without filling in a necessary field" do
    visit "/"
    click_link "Create Account"
    page.fill_in "user_email", with: "OG_Gettysburg@whitehouse.gov"
    page.fill_in "user_password", with: "TheNorth"
    page.fill_in "user_password_confirmation", with: "TheNorth"
    click_button "Submit"

    expect(page).to have_text("Name can't be blank")
  end
end

feature "Uploading an API" do
  background do
    User.create(name: "TheGreek", email: "Plato@athens.gr", organization_id: 1, password: 'password', password_confirmation: 'password')
    Organization.create(name: "Delian League", description: "A buncha Greeks")
  end

  pending "Upload a CSV file" do
    Organization.first.users << User.first
    visit "/sessions/new"

    page.fill_in "session_email", with: "Plato@athens.gr"
    page.fill_in "session_password", with: "password"
    click_button "Login"

    page.attach_file('file', File.path('db/Ward_Offices.csv'))

    page.fill_in "service_name", with: "Ward Offices"
    page.fill_in "service_description", with: "A bunch of wards"
    click_button "Import"
    # stuck here
  end
end

feature "Retrieving data from API endpoints" do
end




