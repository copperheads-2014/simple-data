class Organization < ActiveRecord::Base
  has_many :users
  has_many :services

  validates :name, presence: true
end
