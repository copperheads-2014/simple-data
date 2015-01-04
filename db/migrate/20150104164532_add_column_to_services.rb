class AddColumnToServices < ActiveRecord::Migration
  def change
    add_column :services, :activated, :boolean, default: true
  end
end
