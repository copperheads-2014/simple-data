class ServiceSerializer < BaseSerializer
  attributes :slug, :name, :description, :license
  has_many :versions

  def uri
    service_path(object.slug)
  end
end
