class CreateVersions < ActiveRecord::Migration
  def change
    create_table :versions do |t|
      t.integer :number
      t.integer :service_id
      t.boolean :active, default: true
      t.integer :total_records, null: false, default: 0

      t.timestamps null: false
    end
  end
end
