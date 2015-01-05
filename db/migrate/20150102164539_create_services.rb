class CreateServices < ActiveRecord::Migration
  def up
    create_table :services do |t|
      t.references :organization, null: false
      t.string :description
      t.string :name, null: false
      t.string :slug, null: false
      t.integer :total_records

      t.timestamps
    end
    add_index :services, :organization_id
    # this is a uniqueness validation on lowercase names
    # execute "CREATE UNIQUE INDEX index_services_on_lowercase_name
    #          ON services USING btree (lower(name));"
  end

  def down
    drop_table :services
  end
end
