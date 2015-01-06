class CreateVersionUpdates < ActiveRecord::Migration
  def change
    create_table :version_updates do |t|
      t.belongs_to :version
      t.belongs_to :user
      t.string :filename
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
