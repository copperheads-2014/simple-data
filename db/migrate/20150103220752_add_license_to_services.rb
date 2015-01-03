class AddLicenseToServices < ActiveRecord::Migration
  def change
    add_column :services, :license, :string, default: "MIT"
  end
end
