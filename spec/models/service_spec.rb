require 'rails_helper'

RSpec.describe Service, :type => :model do
  let(:zoo) { Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.", organization_id: 1) }

  describe 'validations' do
    it 'requires the presence of a name' do
      zoo.name = nil
      zoo.valid?
      expect(zoo.errors[:name]).to include("can't be blank")
    end

    it 'requires an organization id' do
      subject.organization_id = nil
      subject.valid?
      expect(subject.errors[:organization_id]).to include("can't be blank")
    end

    it 'fails to create a service with the same name' do
      zoo
      zoo_two = Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.",organization_id: 1)
      expect(zoo_two.errors[:name][0]).to include("has already been taken")
    end

    it 'fails to create a service with the same name of different case sensitivity' do
      zoo
      zoo_two = Service.create(name: "map of Zoos", description: "Description needs to be 12 characters.",organization_id: 1)
      expect(zoo_two.errors[:name][0]).to include("has already been taken")
    end
  end

  describe "#make_slug" do
    it "saves a slug to the database on creation" do
      expect(zoo.slug).to eq("map-of-zoos")
    end
  end


  describe "#set_update_time" do
    it "sets updated_at time" do
      original_time = Time.now - 5.seconds
      zoo.update(updated_at: original_time)
      zoo.set_update_time
      expect(zoo.updated_at).not_to eq(original_time)
    end
  end

  describe "versions" do
    it "sets the version number to 1 if no versions exist" do
      expect(zoo.latest_version.number).to eq(1)
    end

    it "sets the version number to 3 after three versions are made" do
      2.times { zoo.make_version }
      expect(zoo.latest_version.number).to eq(3)
    end
  end


end
