require 'rails_helper'

RSpec.describe Version, :type => :model do
  let(:zoo) { Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.", organization_id: 1) }
  let(:zoo_v1) {Version.create(number: 1, service_id: zoo.id, active: true)}

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

end
