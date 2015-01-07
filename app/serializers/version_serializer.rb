class VersionSerializer < BaseSerializer
  attributes :number, :total_records, :links
  has_many :headers

  def uri
    service_version_path(object.service.slug, object.number)
  end

  def links
    {
      records: version_records_service_path(object.service.slug, object.number)
    }
  end
end
