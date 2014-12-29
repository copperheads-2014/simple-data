class Service
  include Mongoid::Document
  include Mongoid::Timestamps
  field :organization_id, type: Integer
  field :description, type: String
  field :name, type: String
  field :slug, type: String
  field :total_records, type: Integer
  field :version, type: Integer, default: 1
  embeds_many :records

  before_create :make_slug

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  validates :organization_id, presence: true

  def set_total_records
    self.update(total_records: self.records.count)
  end

  def set_update_time
    self.update(updated_at: Time.now )
  end

  def increment_version
    self.version += 1
  end

  def create_records(file)
    file.each { |row| self.records.create(row.to_hash) }
  end

  protected

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end



end

