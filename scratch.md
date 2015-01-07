

Service.all # /services
service = Service.find('elenis_data') # /services/elenis_data
service.records.find_by(address: '123 montgomery lane') # /services/elenis_data/v1/records?filter[address]=123+montgomery+lane
service = Service.find('elenis_data', version: 1) # /services/elenis_data

class Service
  class Client
  end

  def self.all
  end

  def initialize(slug, options={})
  end
end
