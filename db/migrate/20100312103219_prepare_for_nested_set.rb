class PrepareForNestedSet < ActiveRecord::Migration
  def self.up
    remove_column :widgets, :left_id
    remove_column :widgets, :right_id
    add_column :widgets, :lft, :integer
    add_column :widgets, :rgt, :integer
    add_column :widgets, :parent_id, :integer
  end

  def self.down
    add_column :widgets, :left_id, :integer
    add_column :widgets, :right_id, :integer
    remove_column :widgets, :lft
    remove_column :widgets, :rgt
    remove_column :widgets, :parent_id
  end
end
