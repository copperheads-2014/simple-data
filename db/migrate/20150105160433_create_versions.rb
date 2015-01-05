class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :number
      t.integer :service_id
      t.boolean :active
      t.integer :total_records

      t.timestamps null: false
    end
  end
end
