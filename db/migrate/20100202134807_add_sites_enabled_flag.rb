class AddSitesEnabledFlag < ActiveRecord::Migration
  def self.up
    add_column :sites, :enabled, :boolean
  end

  def self.down
    remove_column :sites, :enabled
  end
end
