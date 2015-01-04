class Tag < ActiveRecord::Base
  has_many :service_tags
  validates :name, presence: true
end
