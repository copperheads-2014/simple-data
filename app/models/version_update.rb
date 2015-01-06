class VersionUpdate < ActiveRecord::Base
  belongs_to :version
  belongs_to :user
  validates :filename, presence: true
  enum status: [:pending, :processing, :completed, :failed]
end
