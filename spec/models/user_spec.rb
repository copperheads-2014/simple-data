require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "#initialize" do
    it "adds a user to the database" do
      test_user = User.create(name: "The Greek", email: "Plato@athens.gr", organization_id: 1)
      expect(User.find(test_user.id).name).to eq("The Greek")
    end

    it "fails to add a user when required fields are missing" do
      expect { User.create!(name: "The Roman") }.to raise_error
    end

    pending "a user can update its password"

  end

  describe "#associations" do
    # TURN ON FOREMAN BEFORE THIS TEST
    it "has many services through organizations" do
      tim = User.create(name: "tim", email: 'tim@timmy.com')
      agora = Organization.new(name: "The agora")
      agora.users << tim
      agora.save
      api = Service.create(
        organization_id: agora.id)
      # binding.pry

      expect(tim.organization.services.count).to eq(1)
    end
  end

end
