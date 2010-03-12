class AddWidgetsLeftAndRightId < ActiveRecord::Migration
  def self.up
    add_column :widgets, :left_id, :integer
    add_column :widgets, :right_id, :integer
  end

  def self.down
  end
end
