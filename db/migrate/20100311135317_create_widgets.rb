class CreateWidgets < ActiveRecord::Migration
  def self.up
    create_table :widgets do |t|
      # used for "empty" widgets, which simply aggregate other widgets (maybe removed later on, when vbox / hbox become widgets)
      t.column :direction, :boolean
      # css-class to be applied to the widget (makes most sense for boxes to take advantages of e.g. the sidebar styling)
      t.column :css_class, :string
      # widgets belong to a site network
      t.column :network_id, :integer, :null => false
      # the cell to render (and it's state)
      t.column :cell_name, :string
      t.column :initial_state, :string
    end
  end

  def self.down
    drop_table :widgets
  end
end
