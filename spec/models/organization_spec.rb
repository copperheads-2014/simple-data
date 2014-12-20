require 'rails_helper'

RSpec.describe Organization, :type => :model do
  describe "#initialize" do
    it "adds an organization to the database" do
      timmy = User.create(name: 'Timmy', email: "Timmy2@gmail.com")
      org = Organization.new(name: "The Foundation")
      org.users << timmy
      org.save
      expect(Organization.last.name).to eq("The Foundation")
    end

    it "cannot exist without a user" do
      expect{ Organization.create(name: "The Foundation") }.to raise_error
    end



  end
end
