class CreateServiceTags < ActiveRecord::Migration
  def change
    create_table :service_tags do |t|
      t.belongs_to :tag
      t.belongs_to :service
      t.timestamps
    end
  end
end
