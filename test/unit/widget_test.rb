require 'test_helper'

class WidgetTest < ActiveSupport::TestCase
  should_allow_values_for :cell_name, Conf.available_cells << nil
  should_belong_to :network
  should_validate_presence_of :network_id
  should_have_db_columns :direction, :css_class, :network_id, :cell_name, :initial_state
  # nested set
  should_have_db_columns :lft, :rgt, :parent_id

  context "a vertical box" do
    setup { @widget = Widget.create(:direction => :vertical) }

    should "be recognized correctly" do
      assert @widget.vertical?
      assert @widget.empty?
    end

    should "have the right css class set" do
      assert @widget.css_classes.include?(Widget::VERTICAL_CLASS)
    end
  end

  context "a horizontal box" do
    setup { @widget = Widget.create(:direction => :horizontal) }

    should "be recognized correctly" do
      assert @widget.horizontal?
      assert @widget.empty?
    end

    should "have the right css class set" do
      assert @widget.css_classes.include?(Widget::HORIZONTAL_CLASS)
    end
  end
end
