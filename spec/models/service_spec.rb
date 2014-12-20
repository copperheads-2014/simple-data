require 'rails_helper'

RSpec.describe Service, :type => :model do
  describe "#initialize" do
    it "saves a slug to the database on creation" do
      Service.create(name: "Map of Zoos")
      expect(Service.last.slug).to eq("map-of-zoos")
    end
  end


end
