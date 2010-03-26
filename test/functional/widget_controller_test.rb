require 'test_helper'

class WidgetControllerTest < ActionController::TestCase
  fixtures :sites, :groups, :users

  context "a vertical box with avatar boxes" do
    setup do
      @site = Site.find_by_name 'site1'
      Conf.enable_site_testing(@site)
      network = @site.network

      @vbox = Widget.create(:direction => :vertical, :network_id => network.id)
      assert @vbox.valid?
      @group_boxes = Widget.create!(:cell_name => "group_avatar_boxes",
                                    :initial_state => 'most_active',
                                    :network_id => network.id)
      @group_boxes.move_to_child_of(@vbox)
      assert @group_boxes.valid?
      @user_boxes = Widget.create!(:cell_name => "user_avatar_boxes",
                                   :initial_state => 'most_active',
                                   :network_id => network.id)
      @user_boxes.move_to_child_of(@vbox)
      assert @user_boxes.valid?

      login_as :blue

      get :show, :id => @vbox.id
    end

    should "render widgets css" do
      assert_select 'head' do |head|
        head.join.match /\.hwidget/
      end
    end

    should "render the vertical box" do
      assert_select '.vbox'
      assert_select "#widget_#{@vbox.id}"
    end

    should "render user and group boxes" do
      assert_select '.user_avatar_boxes'
      assert_select "#widget_#{@user_boxes.id}"
      assert_select '.group_avatar_boxes'
      assert_select "#widget_#{@group_boxes.id}"
    end

    context "arranging widgets" do
      setup do
        get :edit, :id => @vbox.id
      end

      should "render the vertical box within a control wrapper and with a handle" do
        assert_select '.widget_handle_wrapper' do |wrappers|
          wrappers.each do |wrapper|
            assert_select wrapper, '.widget_handle'
            assert_select wrapper, "#widget_handle_#{@vbox.id}"
            assert_select wrapper, '.vbox'
            assert_select wrapper, "#widget_#{@vbox.id}"
          end
        end
      end
    end
  end
end
