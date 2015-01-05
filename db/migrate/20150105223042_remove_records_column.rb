class RemoveRecordsColumn < ActiveRecord::Migration
  def change
    remove_column :data_formatters, :records
  end
end
