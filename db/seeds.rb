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

Service.create(
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


popo.each do |row|
  Service.first.records.create(row.to_hash)
end

Service.first.set_total_records
