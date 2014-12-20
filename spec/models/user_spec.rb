require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "#initialize" do
    it "adds a user to the database" do
      test_user = User.create(name: "The Greek", email: "Plato@athens.gr", organization_id: 1)
      expect(User.find(test_user.id).name).to eq("The Greek")
    end

    it "fails to add a user when required fields are missing" do
      roman = User.create(name: "The Roman", email: "Cato@Rome.it")
      # roman.should have(1).error_on(:organization_id)
      # expect(User.find(1).name).to return_error
    end

  end


end
