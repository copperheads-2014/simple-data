require 'rails_helper'

RSpec.describe Service, :type => :model do
  let(:zoo) { Service.create(name: "Map of Zoos", description: "Description", organization_id: 1) }

  describe 'validations' do
    it 'requires the presence of a name' do
      service = Service.create()
      expect(service.errors[:name]).to include("can't be blank")
    end

    it 'requires the presence of a description' do
      service = Service.create()
      expect(service.errors[:description]).to include("can't be blank")
    end

    it 'fails to create a service with the same name' do
      zoo
      zoo_two = Service.create(name: "Map of Zoos", description: "Description",organization_id: 1)
      expect(zoo_two.errors[:name]).to include("is already taken")
    end

    it 'fails to create a service with the same name of different case sensitivity' do
      zoo
      zoo_two = Service.create(name: "map of Zoos", description: "Description",organization_id: 1)
      expect(zoo_two.errors[:name]).to include("is already taken")
    end
  end

  describe "#make_slug" do
    it "saves a slug to the database on creation" do
      expect(zoo.slug).to eq("map-of-zoos")
    end
  end

  describe "#set_total_records" do
    it "sets total records to count of existing records" do
      10.times { zoo.records.create() }
      zoo.set_total_records
      expect(zoo.total_records).to eq(zoo.records.count)
    end
  end

  describe "#set_update_time" do
    it "sets updated_at time" do
      original_time = zoo.updated_at
      sleep(1)
      zoo.set_update_time
      expect(zoo.updated_at).not_to eq(original_time)
    end
  end


end
