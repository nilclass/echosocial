class AddMenuItemsLanguageCode < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :language_code, :string
  end
  
  def self.down
    remove_column :menu_items, :language_code
  end
end
