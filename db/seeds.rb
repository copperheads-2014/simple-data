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



24.times do
  #Create an organization
  org = Faker::Company.name
  #Create an user to belong to the organization
  User.create(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    organization_id: org.id,
    password: 'password',
    password_confirmation: 'password_confirmation'
  )


end
