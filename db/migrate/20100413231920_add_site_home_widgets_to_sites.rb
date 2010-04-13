class AddSiteHomeWidgetsToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :use_widgets, :boolean, :default => false
  end

  def self.down
    remove_column :sites, :use_widgets
  end
end
