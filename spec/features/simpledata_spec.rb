require 'rails_helper'
require 'csv'

feature "Browsing the website" do
  scenario "User visits the landing page" do
    visit '/'
    expect(page).to have_text("Give us your data")
  end

  scenario "User clicks get started button and is redirected to account creation page" do
    visit '/'
    within("#createapi") do
      click_link "Create API"
    end
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
    click_link "Browse APIs"
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

    click_link "Your Organization"

    expect(page).to have_text("Delian League's APIs:")
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

    expect(page.current_path).to eq("/users/#{User.last.id}")
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
    within("#createapi") do
      click_link "Create API"
    end
    page.fill_in "user_name", with: "US Grant"
    page.fill_in "user_email", with: "OG_Gettysburg@whitehouse.gov"
    page.fill_in "user_password", with: "TheNorth"
    page.fill_in "user_password_confirmation", with: "TheNorth"
    click_button "Submit"

    expect(page.current_path).to eq("/organizations/new")
  end

  scenario "User tries to create an account without filling in a necessary field" do
    visit "/"
    within("#createapi") do
      click_link "Create API"
    end
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
  background do
    service = Service.create(organization_id: 1, description: "This is a description of the service", name: "my service", creator_id: 1)
    version = service.latest_version
    version.create_records(CSV.read('db/samples/Life_Safety_Evaluations.csv',
      headers: true))

    # CsvImporter.


  end
  scenario 'returns total number of record' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"total":733')

  end

  scenario 'contains an insertion id' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"insertion_id":1')
  end

  scenario 'captures the number of items on a page in the metadata' do
    visit "/services/my-service/v1/records?page_size=10"

    expect(page).to have_content('page_size":10')
  end

  scenario 'shows that the starting point is 0' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"start":0')
  end


  scenario 'shows that the ending point for the page is 49' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"end":49')
  end

  scenario 'tells you the correct number of pages' do
    visit "/services/my-service/v1/records?page_size=50"

    expect(page).to have_content('"num_pages":15')
  end

  scenario 'returns the base uri' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"uri":"/services/my-service/v1/records"')
  end

  scenario 'returns the next page uri' do
    visit "/services/my-service/v1/records?page=0&page_size=50"

    expect(page).to have_content('"next_page_uri":"/services/my-service/v1/records?page=1&page_size=50"')
  end

  scenario 'returns the previous page uri' do
    visit "/services/my-service/v1/records?page=1&page_size=50"

    expect(page).to have_content('"previous_page_uri":"/services/my-service/v1/records?page=0&page_size=50"')
  end

  scenario 'returns null for previous page uri if on the first page' do
    visit "/services/my-service/v1/records?page=0"

    expect(page).to have_content('"previous_page_uri":null')
  end

  scenario 'returns null for next page uri if on the last page' do
    visit "/services/my-service/v1/records?page=15&page_size=50"

    expect(page).to have_content('"next_page_uri":null')
  end

  scenario 'returns data as an array' do
    visit "/services/my-service/v1/records"

    expect(page).to have_content('"data":[')
  end

  scenario 'does not show mongo id"' do
    visit "/services/my-service/v1/records"

    expect(page).to_not have_content('$oid')
  end

  scenario 'if specified, shows only fields specified' do
    visit version_records_service_path("my-service","v1", {:only => "Building Street Direction,Building Street Name"})
    expect(page).to have_content('{"Building Street Direction":"W.","Building Street Name":"21st"}')
  end

  scenario 'filters by one field properly' do
    visit version_records_service_path("my-service", "v1", {filter: {"Report Status - Original LSE Report Approved" => "No"}})

    expect(page).to have_content('"total":381')
  end

  scenario 'filters by two fields properly' do
    visit version_records_service_path("my-service", "v1", {filter: {"Report Status - Original LSE Report Approved" => "No", "Report Status - Resubmitted Report Approved" => "Yes"}})

    expect(page).to have_content('"total":359')
  end

  scenario 'orders by desc properly' do
    visit "/services/my-service/v1/records?order=desc"

    expect(page).to have_content('"insertion_id":733')
  end

  scenario 'orders by asc properly' do
    visit "/services/my-service/v1/records?sortby=insertion_id"

    expect(page).to have_content('3030')
  end

  scenario 'skips records properly' do
    visit "/services/my-service/v1/records?page=2"

    expect(page).to have_content('"start":100')
  end


  scenario 'sorts properly' do
    visit "/services/my-service/v1/records?sortby=building_street_name"

    expect(page).to have_content('"Building Street Number":"3030"')
  end

  scenario 'limits the number of results' do
    visit "/services/my-service/v1/records?page_size=1"

    expect(page).to_not have_content('"insertion_id":2')
  end

end




