class User < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true
  validates :organization_id, presence: true

  belongs_to :organization
end
