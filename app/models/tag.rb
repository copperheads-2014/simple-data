class Tag < ActiveRecord::Base
  has_many :service_tags
  has_many :services, through: :service_tags
  validates :name, presence: true
end
