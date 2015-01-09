class VersionsController < ApplicationController
  def index
    @service = Service.find_by(slug: params[:service_slug])
    @versions = @service.versions
  end

  def show
    @service = Service.find_by(slug: params[:service_slug])
    @version = @service.versions.find_by(number: params[:id])
    @organization = Organization.find_by(id: @service.organization_id)
    @first_record = @service.latest_version.records.first
    @attributes = @first_record.attributes
    @attributes.delete("_id")
    @response = metadata_options
    # @headers = Header.find_by(version_id: params[:version_id]).map(&:name)
    # Figure out headers
  end

  protected

  def metadata_options
    "{
      \"start\": 0,
      \"end\": 49,
      \"total\": 314,
      \"num_pages\": 7,
      \"page\": 0,
      \"page_size\": 50,
      \"uri\": #{uri},
      \"first_page_uri\": \"#{uri}?page=0&page_size=50\",
      \"last_page_uri\": \"#{uri}?page=6&page_size=50\",
      \"previous_page_uri\": null,
      \"next_page_uri\": \"#{uri}?page=1&page_size=50\"
      \"data\": [
          {\n"+@attributes.map{|k,v| "  \t\t\"#{k}\": \"#{v}\""}.join(",\n")+"\n\t}
       ]
    }"
  end

  def uri
    "https://dbc-simpledata.herokuapp.com/services/#{@version.service.slug}/v#{@version.number}/records"
  end


end
