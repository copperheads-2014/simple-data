class User < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true

  belongs_to :organization

  has_secure_password
end
