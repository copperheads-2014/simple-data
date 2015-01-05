class Service < ActiveRecord::Base
  belongs_to :organization
  has_many :service_updates
  has_many :service_tags
  has_many :tags, through: :service_tags
  has_many :versions

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true, length: { :in => 12..300 }
  validates :slug, presence: true, on: :save

  after_create :make_version

  before_create :make_slug

  def records
    Record.with(collection: self.collection)
  end

  def insert_record(record)
    records.create!(record)
  end


  def set_update_time
    self.update(updated_at: Time.now )
  end

  def create_records(file)
    last_count = total_records
    file.each do |row|
      row_hash = row.to_hash
      row_hash[:insertion_id] = last_count += 1
      insert_record(row_hash)
    end
  end

  def add_tags(params)
    array = params.split(",").map(&:strip).map(&:downcase)
    array.each do |name|
      tags << Tag.find_or_create_by(name: name)
    end
  end

  def deactivate
    self.update(activated: false)
  end

  def activate
    self.update(activated: true)
  end

  def show_headers
    latest_version.headers
  end

  def make_version
    versions << Version.create(number: 1, active: true, total_records: 0)
  end

  protected

  def collection
    slug.underscore.camelize
  end

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end
end
