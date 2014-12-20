class Service
  include Mongoid::Document
  field :organization_id, type: Integer
  field :description, type: String
  field :name, type: String
  embeds_many :records
end

