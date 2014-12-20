class Organization < ActiveRecord::Base
  has_many :users

  def services
    Service.where(organization_id: self.id)
  end
end
