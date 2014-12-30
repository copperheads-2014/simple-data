class HeaderMetadata
  include Mongoid::Document
  include Mongoid::Attributes::Dynamic

  embedded_in :service


end
