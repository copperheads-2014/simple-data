# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.create(
  name: "Melian League")

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

popo = CSV.read('db/Police_Stations.csv', headers: true)

popo.each_with_index do |row, i|
  Service.first.records.create(row.to_hash)
end
