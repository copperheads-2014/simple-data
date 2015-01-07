class CreateHeaders < ActiveRecord::Migration
  def change
    create_table :headers do |t|
      t.string :name
      t.text :description
      t.string :type
      t.integer :version_id

      t.timestamps null: false
    end
  end
end
