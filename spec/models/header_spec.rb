require 'rails_helper'

RSpec.describe Header, :type => :model do
  let(:zoo) { Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.", organization_id: 1) }
  let(:zoo_v1) {Version.create(service_id: zoo.id, active: true)}

  describe "Initialization" do
    it "Fails to save to the database if a version_id is not provided" do
      Header.create(name: "More Arbitrary", description: "Can this get any more generic?")
      expect(Header.exists?(name: "More Arbitrary")).to eq(false)
    end

    it "Can be created" do
      Header.create(name: "Arbitrary", description: "An arbitrary header", version_id: 1)
      expect(Header.last.name).to eq("Arbitrary")
    end
  end

  describe "Assocations" do
    it "belongs to a version" do
      Header.create(name: "My skull", description: "It's made of bone", version_id: zoo_v1.id )
      expect(zoo_v1.headers.last.name).to eq("My skull")
    end
  end




end
