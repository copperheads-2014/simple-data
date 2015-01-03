class Service < ActiveRecord::Base
  belongs_to :organization

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :slug, presence: true, on: :save

  before_create :make_slug

  def records
    Record.with(collection: self.collection)
  end

  def insert_record(record)
    records.create!(record)
  end

  def increment_version
    self.update(version: version += 1)
  end

  def set_total_records
    # TODO: replace with counter_column maybe?
    self.update(total_records: self.records.count)
  end

  def set_update_time
    self.update(updated_at: Time.now )
  end

  def create_records(file)
    file.each do |row|
      insert_record(row.to_hash)
    end
  end

  protected

  def collection
    slug.underscore.camelize
  end

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end
end
