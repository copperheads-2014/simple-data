require 'rails_helper'

RSpec.describe Organization, :type => :model do

  let(:opec)  { Organization.create(name: "Organization of Petroleum Exporting Countries", description: "This is a description for an organization.") }
  let(:timmy) { User.create(name: 'Timmy', email: "Timmy2@gmail.com", password: 'password', password_confirmation: 'password') }

  describe "#initialize" do
    it "adds an organization to the database" do
      opec.users << timmy
      expect(Organization.last.name).to eq("Organization of Petroleum Exporting Countries")
    end
  end

  describe "validations" do
    it "fails to add an organization without a name" do
      opec.name = nil
      opec.valid?
      expect(opec.errors[:name]).to include("can't be blank")
    end
  end

  describe "associations" do
    it "has users" do
      opec.users << timmy
      expect(opec.users.first.name).to eq("Timmy")
    end

    it "has services" do
      oilfields = Service.create(organization_id: 1, name: "Middle Eastern Oilfields", description: "A bunch of black gold")
      opec.services << oilfields
      expect(opec.services.first.name).to eq("Middle Eastern Oilfields")
    end
  end

end
