require 'rails_helper'

RSpec.describe Version, :type => :model do
  let(:user) {User.new(name: "The Ringkeeper", email: "BarnumNBailey@gmail.com", password: "password", password_confirmation: "password", organization_id: 1)}
  let(:zoo) { Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.", organization_id: 1, creator_id: 1) }
  let(:zoo_v1) {Version.create(service_id: zoo.id, active: true)}

  describe "#set_total_records" do
    it "sets total records to count of existing records" do
      10.times { zoo_v1.records.create() }
      zoo_v1.set_total_records
      expect(zoo_v1.total_records).to eq(zoo_v1.records.count)
    end
  end

  describe "#set_initial_total_records" do
    it "sets total records to 0 when a version is created" do
      union = Service.create(name: "The Union", description: "How old are these civil war analogies getting?", organization_id: 1)
      union.make_version
      expect(union.latest_version.total_records).to eq(0)
    end
  end

  describe "Associations" do
    it "belongs to a service" do
      expect(zoo_v1.service.name).to eq("Map of Zoos")
    end

    it "has many headers" do
      zoo_v1.headers << Header.new(name: "The first header", description: "A header")
      zoo_v1.headers << Header.new(name: "The second header", description:"A header")

      expect(zoo_v1.headers.count).to eq(2)
    end

    it "can access properties of a single header" do
      zoo_v1.headers << Header.new(name: "The first header", description: "A header")
      zoo_v1.headers << Header.new(name: "The second header", description:"A header")

      expect(zoo_v1.headers.first.name).to eq("The first header")
    end

    it "has many version_updates" do
      zoo_v1.make_version_update('some file.csv')
      zoo_v1.make_version_update('another file.csv')
      expect(zoo_v1.updates.count).to eq(2)
    end


  end



end
