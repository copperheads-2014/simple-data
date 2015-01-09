# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

Organization.create(
  name: "Delian League", description: "Keeping peace in the Mediterranean")

eleni = User.create(
  name: "Eleni Chappen",
  email: "athens@greece.com",
  organization_id: 1,
  password: 'password',
  password_confirmation: 'password')

passage = ServiceCreation.create({
    description: "A list of safe passages for children",
    name: "Safe Passages",
  }, eleni)

passage.latest_version.create_records(CSV.read(
  'db/samples/safepassage_buffer.csv',
   headers: true,
  :header_converters => lambda { |h| h.downcase.gsub(' ','_') unless h.nil?}
))

passage_headers = CSV.readlines("db/samples/safepassage_buffer.csv").first
passage.latest_version.headers = passage_headers.map { |name| Header.create(name: name) }
passage.latest_version.save!

passage.latest_version.headers.find_by(name: "OBJECTID").update(data_type: 'integer', description: "The object's ID")
passage.latest_version.headers.find_by(name: "SCHOOL_NAM").update(data_type: 'text', description: "The name of the school")
passage.latest_version.headers.find_by(name: "ROUTE_NUMB").update(data_type: 'integer', description: "The route number")
passage.latest_version.headers.find_by(name: "SHAPE_LENG").update(data_type: 'decimal', description: "The direct length")
passage.latest_version.headers.find_by(name: "BUFF_DIST").update(data_type: 'integer', description: "The buffer distance")
passage.latest_version.headers.find_by(name: "SHAPE_AREA").update(data_type: 'decimal', description: "The area of the shape")
passage.latest_version.headers.find_by(name: "SHAPE_LEN").update(data_type: 'decimal', description: "The secondary shape length")
passage.latest_version.headers.find_by(name: "SCHOOLID").update(data_type: 'integer', description: "The ID of the school")



services = [
  # "311_Service_Requests_-_Tree_Debris.csv",
  # "311_Service_Requests_-_Vacant_and_Abandoned_Buildings_Reported.csv",
  "Affordable_Rental_Housing_Developments.csv",
  "Average_Daily_Traffic_Counts.csv",
  # "Bike_Racks.csv",
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

  user = User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    organization: Organization.create(name: Faker::Company.name, description: Faker::Company.catch_phrase),
    password: 'password',
    password_confirmation: 'password'
  )

  service = ServiceCreation.create({
    description: Faker::Company.bs,
    name: "#{file}".chomp('.csv'),
    }, user)

  service.latest_version.create_records(CSV.read(
    "db/samples/#{file}",
    headers: true
    ))

  update = VersionUpdate.create!(version_id: service.latest_version.id, user_id: user.id, filename: "db/#{file}", status: :completed)

  headers = CSV.readlines("db/samples/#{file}").first
  service.latest_version.headers = headers.map { |name| Header.create(name: name) }
  service.latest_version.save!

end
