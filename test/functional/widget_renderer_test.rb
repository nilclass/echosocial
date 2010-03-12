require 'test_helper'

class WidgetRendererTest < ActionController::TestCase
  include Cells::AssertionsHelper
  fixtures :sites

  self.controller_class = RootController

  context "a vertical box with avatar boxes" do
    setup do
      @site = Site.find_by_name('site1')
      @site.network = Network.make(:name => 'site1')
      @site.save!
      Conf.enable_site_testing(@site)

      network = @site.network

      assert_not_nil network
      assert_not_nil @controller

      @renderer = WidgetRenderer.new(@controller)
      @vbox = Widget.create(:direction => :vertical, :network_id => network.id)
      assert @vbox.valid?
      group_boxes = Widget.create!(:cell_name => "group_avatar_boxes",
                                   :initial_state => 'most_active',
                                   :network_id => network.id)
      group_boxes.move_to_child_of(@vbox)
      assert group_boxes.valid?
      user_boxes = Widget.create!(:cell_name => "user_avatar_boxes",
                                  :initial_state => 'most_active',
                                  :network_id => network.id)
      user_boxes.move_to_child_of(@vbox)
      assert user_boxes.valid?

      # there has to be a request for @controller to be setup correctly
      # (even though we don't use it here)
      get :index

      # render the widget
      @result = @renderer.render(@vbox)
    end

    should "not return an empty result" do
      assert @result.any?
    end
  end
end
