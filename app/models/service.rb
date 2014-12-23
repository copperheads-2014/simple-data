class Service
  include Mongoid::Document
  include Mongoid::Timestamps
  field :organization_id, type: Integer
  field :description, type: String
  field :name, type: String
  field :slug, type: String
  field :total_records, type: Integer
  embeds_many :records

  before_create :make_slug, :set_total_records

  validates :name, uniqueness: {case_sensitive: false}

  def set_total_records
    self.total_records = self.records.count
  end

  protected

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end



end

