class ServiceCreation
  attr_reader :attributes, :service
  def initialize(service_attributes, user)
    @attributes = service_attributes
    @user = user
  end

  def self.create(service_attributes, user)
    new(service_attributes, user).save
  end

  def self.new(service_attributes, user)
    return new(service_attributes, user)
  end

  def save
    @service = Service.new(attributes)
    @service.organization_id = @user.organization_id
    @service.creator_id = @user.id
    @service.save!
    @service
  end
end
