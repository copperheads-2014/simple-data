class User < ActiveRecord::Base

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :password, length: { minimum: 8}, on: :create

  belongs_to :organization

  after_create :generate_token

  has_secure_password

  def generate_token
    token = SecureRandom.urlsafe_base64
    save
  end
end
