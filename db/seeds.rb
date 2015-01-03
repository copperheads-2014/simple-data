# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.create(
  name: "Delian League")

User.create(
  name: "Eleni Chappen",
  email: "athens@greece.com",
  organization_id: 1,
  password: 'password',
  password_confirmation: 'password')

police = Service.create(
  organization_id: 1,
  description: "a list of all the popos",
  name: "Police Stations")

# This downcases all headers and replaces spaces in headers with underscores. Will need to implement this in our app when we convert CSV's to Records.
popo = CSV.read(
  'db/Police_Stations.csv',
  headers: true,
  :converters => :all,
  :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
  )

police.create_records(popo)


services = [
  # "311_Service_Requests_-_Tree_Debris.csv",
  # "311_Service_Requests_-_Vacant_and_Abandoned_Buildings_Reported.csv",
  "Affordable_Rental_Housing_Developments.csv",
  "Average_Daily_Traffic_Counts.csv",
  "Bike_Racks.csv",
  # "Business_Licenses_-_Current_Active.csv",
  # "Business_Owners.csv",
  # "Census_Data_-_Languages_spoken_in_Chicago__2008__2012",
  "Chicago_Street_Names.csv",
  "CTA_-_List_of_CTA_Datasets.csv",
  "Libraries_-_Locations__Hours_and_Contact_Information.csv",
  "Life_Safety_Evaluations.csv",
  # "Lobbyist_Data_-_Lobbyist_Registry_-_2012_to_present.csv",
  "Mental_Health_Clinics.csv",
  "Neighborhood_Health_Clinics_-_Historical.csv",
  # "Public_Chauffeurs.csv",
  "Schools.csv",
  "Senior_Centers.csv",
  "Street_Closure_Permits_-_Current.csv",
  "Towed_Vehicles.csv",
  "Ward_Offices.csv",
  "Women__Infant__Children_Health_Clinics.csv"
]

services.each do |file|
  org = Organization.create(name: Faker::Company.name)
  #Create an user to belong to the organization
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    organization_id: org.id,
    password: 'password',
    password_confirmation: 'password'
  )

  service = Service.create(
    organization_id: org.id,
    description: "#{file}",
    name: "#{file}")

  data = CSV.read(
  "db/#{file}",
  headers: true,
  :converters => :all,
  :header_converters => lambda { |h| h.downcase.gsub(' ', '_') unless h.nil? }
  )

  service.create_records(data)
end