require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "#initialize" do
    it "adds a user to the database" do
      test_user = User.create(name: "The Greek", email: "Plato@athens.gr", organization_id: 1, password: 'password', password_confirmation: 'password')
      expect(User.find(test_user.id).name).to eq("The Greek")
    end

    context 'presence' do
      it "fails to add a user when password is missing" do
        expect { User.create!(name: "The Roman", email: "email@email.com", organization_id: 1) }.to raise_error
      end

      it "fails to add a user when name is missing" do
        expect { User.create!(email: "email@email.com", organization_id: 1, password: 'password', password_confirmation: 'password') }.to raise_error
      end

      it "fails to add a email when name is missing" do
        expect { User.create!(name: "The Roman", organization_id: 1, password: 'password', password_confirmation: 'password') }.to raise_error
      end
    end

    context 'validations' do
      it 'requires email to be unique' do
        User.create(name: "The Greek", email: "Plato@athens.gr", organization_id: 1, password: 'password', password_confirmation: 'password')
        duplicate = User.create(name: "The geek", email: "Plato@athens.gr", organization_id: 1, password: 'password1', password_confirmation: 'password1')
        expect(duplicate.errors[:email]).to include("has already been taken")
      end

      it 'requires a email to include @' do
        user = User.create(name: "The Greek", email: "Platoathens.gr", organization_id: 1, password: 'password', password_confirmation: 'password')
        expect(user.errors[:email]).to include("is invalid")
      end

      it 'requires password to be at least 8 characters' do
        user = User.create(name: "The Greek", email: "Plato@athens.gr", organization_id: 1, password: 'passwor', password_confirmation: 'passwor')
        expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
      end
    end

    pending "a user can update its password"

  end

  describe "#associations" do
    # TURN ON FOREMAN BEFORE THIS TEST
    it "has many services through organizations" do
      # We need to look at using doubles for this test
      tim = User.create(name: "tim", email: 'tim@timmy.com')
      agora = Organization.new(name: "The agora", description: "This is a longer description")
      agora.save
      agora.users << tim
      api = Service.create(
        organization_id: agora.id, name: "The Senate", description: "This is a longer description")
      expect(tim.organization.services.count).to eq(1)
    end
  end

end
