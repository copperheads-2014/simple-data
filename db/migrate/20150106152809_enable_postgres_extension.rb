class EnablePostgresExtension < ActiveRecord::Migration
  def change
    enable_extension "json"
  end
end
