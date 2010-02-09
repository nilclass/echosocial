class AddLocalizedPagesFlagToSites < ActiveRecord::Migration
  def self.up
    add_column :sites, :localized_pages, :boolean, :default => false
  end

  def self.down
    remove_column :sites, :localized_pages
  end
end
