module UploadCsvHelper
  def url
    parent_url = super
    # If the url is nil, there's no need to look in the bucket for it
    return nil if parent_url.nil?

    # This will give you the last part of the URL, the 'key' params you need
    # but it's URL encoded, so you'll need to decode it
    object_key = parent_url.split(/\//).last
    AWS::S3::S3Object.url_for(
      CGI::unescape(object_key),
      ENV['S3_BUCKET'],
      use_ssl: true)
  end
end
