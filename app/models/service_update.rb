class ServiceUpdate < ActiveRecord::Base
  belongs_to :service

  def set_records_added(initial, current)
    added = current - initial
    self.update(records_added: added)
  end

end
