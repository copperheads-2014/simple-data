class Organization < ActiveRecord::Base
  has_many :users
  # validate :organization_has_users

  # def organization_has_users
  #   if self.users.size == 0
  #     errors.add("Organization must have at least one user")
  #   end
  # end

  def services
    Service.where(organization_id: self.id)
  end
end
