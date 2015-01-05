class AddDataColumn < ActiveRecord::Migration
  def change
    add_column :data_formatters, :data, :json
  end
end
