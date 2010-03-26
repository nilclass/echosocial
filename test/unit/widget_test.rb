require 'test_helper'

class WidgetTest < ActiveSupport::TestCase
  fixtures :sites, :groups

  should_allow_values_for :cell_name, Conf.available_cells << nil
  should_belong_to :network
  should_validate_presence_of :network_id
  should_have_db_columns :direction, :css_class, :network_id, :cell_name, :initial_state
  # nested set
  should_have_db_columns :lft, :rgt, :parent_id

  context "a vertical box" do
    setup { @widget = Widget.create(:direction => :vertical,
                                    :network_id => Site.find_by_name('site1').network.id) }

    should "be valid" do
      assert @widget.valid?
    end

    should "be recognized correctly" do
      assert @widget.vertical?
      assert @widget.empty?
    end

    should "have the right css class set" do
      assert @widget.css_classes.include?(Widget::VERTICAL_CLASS)
    end
  end

  context "a horizontal box" do
    setup { @widget = Widget.create(:direction => :horizontal,
                                    :network_id => Site.find_by_name('site1').network.id) }

    should "be valid" do
      assert @widget.valid?
    end

    should "be recognized correctly" do
      assert @widget.horizontal?
      assert @widget.empty?
    end

    should "have the right css class set" do
      assert @widget.css_classes.include?(Widget::HORIZONTAL_CLASS)
    end
  end

  context "group avatar boxes" do
    setup {
      @widget = Widget.create(:cell_name => 'group_avatar_boxes',
                              :initial_state => 'most_active',
                              :network_id => Site.find_by_name('site1').network.id)
    }

    should "be valid" do
      assert @widget.valid?
    end

    should "have it's cell name included in the css classes" do
      assert @widget.css_classes.include?(@widget.cell_name)
    end

    should "return the right dom_id" do
      assert_equal "widget_#{@widget.id}", @widget.dom_id
    end

    context "wrapped by a hbox" do
      setup {
        @vbox = Widget.create(:direction => :horizontal,
                              :network_id => Site.find_by_name('site1').network.id)
        assert @vbox.valid?
        @widget.move_to_child_of(@vbox)
        assert @widget.valid?
        @widget.save
      }

      should "have 'hwidget' in it's CSS classes" do
        assert @widget.css_classes.include?(Widget::HORIZONTAL_CHILD_CLASS)
      end
    end
  end
end
