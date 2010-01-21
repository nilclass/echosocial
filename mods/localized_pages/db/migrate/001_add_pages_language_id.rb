class AddPagesLanguageId < ActiveRecord::Migration
  def self.up
    add_column :pages, :language_code, :string
  end
  
  def self.down
    remove_column :pages, :language_code
  end
end
