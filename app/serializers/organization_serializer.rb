class OrganizationSerializer < BaseSerializer
  attributes :id, :name, :description, :created_at, :updated_at

  has_many :services, serializer: ServicePreviewSerializer
end
