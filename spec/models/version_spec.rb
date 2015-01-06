require 'rails_helper'

RSpec.describe Version, :type => :model do
  let!(:zoo) { Service.create(name: "Map of Zoos", description: "Description needs to be 12 characters.", organization_id: 1) }
  let(:zoo_v1) {Version.create(number: 1, service_id: zoo.id, active: true, total_records: 0)}

  describe "#set_total_records" do
    it "sets total records to count of existing records" do
      10.times { zoo_v1.records.create() }
      zoo_v1.set_total_records
      expect(zoo_v1.total_records).to eq(zoo_v1.records.count)
    end
  end
end
