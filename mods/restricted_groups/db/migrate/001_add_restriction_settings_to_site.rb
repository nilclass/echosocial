class AddRestrictionSettingsToSite < ActiveRecord::Migration
  def self.up
    add_column :sites, :group_creation_restricted, :boolean, :default => false
    add_column :sites, :group_tab_visible, :boolean, :default => true

    add_column :sites, :network_creation_restricted, :boolean, :default => false
    add_column :sites, :network_tab_visible, :boolean, :default => true
  end

  def self.down
    remove_column :sites, :group_creation_restricted
    remove_column :sites, :group_tab_visible
    remove_column :sites, :network_creation_restricted
    remove_column :sites, :network_tab_visible
  end
end
