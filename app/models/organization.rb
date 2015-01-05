class Organization < ActiveRecord::Base
  has_many :users
  has_many :services

  validates :name, presence: true
  validates :description, presence: true, length: { :in => 12..300 }

end
