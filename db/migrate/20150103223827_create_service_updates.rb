class CreateServiceUpdates < ActiveRecord::Migration
  def change
    create_table :service_updates do |t|
      t.belongs_to :service
      t.integer :user_id
      t.integer :records_added
      t.timestamps
    end
  end
end
