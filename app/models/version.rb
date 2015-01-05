class Version < ActiveRecord::Base

  belongs_to :service
  validates :number, presence: true
  validates :total_records, presence: true

  # after_initialize :set_initial_total_records

  # def set_initial_total_records
  #   self.total_records = 0
  # end

  def set_total_records
    # TODO: replace with counter_column maybe?
    self.update(total_records: self.records.count)
  end


end
