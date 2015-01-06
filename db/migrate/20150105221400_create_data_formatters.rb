class CreateDataFormatters < ActiveRecord::Migration
  def change
    create_table :data_formatters do |t|
      t.integer :start
      t.integer :end
      t.integer :total
      t.integer :num_pages
      t.integer :page
      t.integer :page_size
      t.string :uri
      t.string :first_page_uri
      t.string :last_page_uri
      t.string :previous_page_uri
      t.string :next_page_uri
      t.string :records

      t.timestamps null: false
    end
  end
end
