class AddCasSettingsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :cas_auth, :boolean
    add_column :sites, :cas_base_url, :string
  end

  def self.down
    remove_column :sites, :cas_auth
    remove_column :sites, :cas_base_url
  end
end
