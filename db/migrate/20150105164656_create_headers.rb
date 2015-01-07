class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.string :name
      t.text :description
      t.string :data_type
      t.integer :version_id, default: 1

      t.timestamps null: false
    end
  end
end
