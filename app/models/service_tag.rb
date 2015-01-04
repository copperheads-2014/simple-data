class ServiceTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :service
end
