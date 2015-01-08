class Service < ActiveRecord::Base
  attr_accessor :name, :description
  belongs_to :organization
  belongs_to :creator, class_name: "User"
  has_many :service_updates
  has_many :service_tags
  has_many :tags, through: :service_tags
  has_many :versions

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  validates :slug, presence: true, on: :save

  after_save :make_version

  before_save :make_slug
  self.per_page = 10

  def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    where("title like ?", "%#{query}%")
  end

  def set_update_time
    self.update(updated_at: Time.now )
  end

  def add_tags(params)
    array = params.split(",").map(&:strip).map(&:downcase)
    array.each do |name|
      tags << Tag.find_or_create_by(name: name)
    end
  end

  def deactivate
    self.update_column('activated', false)
  end

  def activate
    self.update_column('activated', true)
  end

  def show_headers
    latest_version.headers
  end

  def make_version
    # Make a new version with an incremented number if any other versions exist.
    versions << Version.create(number: self.latest_version.number + 1, active: true) if Version.exists?(service_id: self.id)
    # Make the first version if no other versions exist.
    versions << Version.create(number: 1, active: true) unless Version.exists?(service_id: self.id)
  end

  def latest_version
    versions.last
  end

  def create_records(file)
    latest_version.create_records(file)
  end

  protected

  def make_slug
    self.slug = self.name.split(" ").map(&:downcase).join("-")
  end
end
