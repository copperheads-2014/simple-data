class AddCreatorToServices < ActiveRecord::Migration
  def change
    add_column :services, :creator_id, :integer
  end
end
