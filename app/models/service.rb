class Service < ActiveRecord::Base
  belongs_to :organization
  belongs_to :creator, class_name: "User"
  has_many :service_updates
  has_many :service_tags
  has_many :tags, through: :service_tags
  has_many :versions
  paginates_per 10

  validates :organization_id, presence: true
  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true
  validates :slug, presence: true, on: :save

  after_save :make_version

  before_save :make_slug


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
    self.update(activated: false)
  end

  def activate
    self.update(activated: true)
  end

  def show_headers
    latest_version.headers
  end

  def make_version
    versions << Version.create(number: self.latest_version.number + 1, active: true) if Version.exists?(service_id: self.id)
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
