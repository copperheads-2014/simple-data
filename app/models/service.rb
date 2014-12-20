class Service
  include Mongoid::Document
  field :organization_id, type: Integer
  field :description, type: String
  field :name, type: String
  field :slug, type: String
  embeds_many :records

  before_create :make_slug

  validates :name, uniqueness: {case_sensitive: false}

  protected

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end

end

