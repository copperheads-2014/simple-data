class Version < ActiveRecord::Base

  belongs_to :service
  has_many :headers
  validates :number, presence: true
  validates :total_records, presence: true
  has_many :updates, class_name: "VersionUpdate"

  before_create :set_initial_total_records

  def set_initial_total_records
    self.total_records = 0
  end

  def records
    Record.with(collection: self.collection)
  end

  def make_version_update(filename)
    self.updates << VersionUpdate.create(user_id: self.service.creator_id, filename: filename)
  end

  def insert_record(record)
    records.create!(record)
  end

  def collection
    service.slug.underscore.camelize + "V#{number}"
  end

  def set_total_records
    self.update(total_records: self.records.count)
  end

  def create_records(file)
    count = total_records
    file.each do |row|
      row_hash = row.to_hash
      row_hash[:insertion_id] = count += 1
      insert_record(row_hash)
    end
    set_total_records
  end

end
