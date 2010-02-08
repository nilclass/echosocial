require File.dirname(__FILE__) + '/../test_helper'

class GroupsControllerTest < ActionController::TestCase
  fixtures :groups, :users, :memberships, :profiles, :pages, :sites,
            :group_participations, :user_participations, :tasks, :page_terms

  include UrlHelper

  def test_create_group_with_council
    login_as :gerrard
    get :new
    assert_response :success

    assert_difference 'Group.count', 2 do # group count increments by 2 (one for the group, one for the council)
      post :create, :group => {:name => 'test-create-group-with-council', :full_name => "Group for Testing Group Creation!", :create_council => true}
      assert_response :redirect
      group = Group.find_by_name 'test-create-group-with-council'
      assert group.council != group
      assert_redirected_to url_for_group(group, :action => 'edit')
    end
  end

  def test_create_group_without_council
    login_as :gerrard
    get :new
    assert_response :success

    assert_difference 'Group.count' do
      post :create, :group => {:name => 'test-create-group-without-council', :full_name => "Group for Testing Group Creation!", :create_council => false}
      assert_response :redirect
      group = Group.find_by_name 'test-create-group-without-council'
      assert group.council == group
      assert_redirected_to url_for_group(group, :action => 'edit')
    end
  end
end
