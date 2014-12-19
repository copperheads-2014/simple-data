class Service
  include Mongoid::Document
  field :user_id, type: Integer
  field :description, type: String
  field :name, type: String
  embeds_many :records
  embeds_many :records_metadata
end

