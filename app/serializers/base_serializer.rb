class BaseSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  attributes :uri

  def uri
    polymorphic_path(object)
  end
end
