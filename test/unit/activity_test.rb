require File.dirname(__FILE__) + '/../test_helper'

class ActivityTest < ActiveSupport::TestCase
  fixtures :users, :groups, :activities, :memberships, :federatings, :sites

  def current_site
    Site.find_by_network_id(3002)  # we are using the second site with animals here.
  end

  def test_contact
    u1 = users(:kangaroo)
    u2 = users(:iguana)

    u1.add_contact!(u2)

    act = FriendActivity.for_dashboard(u1,current_site).find(:first)
    assert_equal u1, act.user
    assert_equal u2, act.other_user
  end

  def test_user_destroyed
    u1 = users(:kangaroo)
    u2 = users(:iguana)

    assert u1.peer_of?(u2)
    username = u2.name
    u2.destroy

    act = UserDestroyedActivity.for_dashboard(u1,current_site).find(:first)
    assert_equal username, act.username
  end

  def test_group_destroyed
    user = users(:kangaroo)
    group = groups(:animals)

    assert user.member_of?(group)
    groupname = group.name
    group.destroy

    acts = Activity.for_dashboard(user,current_site).find(:all)
    act = acts.detect{|a|a.class == GroupDestroyedActivity}
    assert_equal groupname, act.groupname
  end

  def test_membership
    group = groups(:animals)
    user = users(:green)
    notified_user = users(:kangaroo)

    group.add_user!(user)

    # animals are on other site...
    assert_nil GroupGainedUserActivity.for_dashboard(notified_user,Site.default).find(:first)
    act = GroupGainedUserActivity.for_dashboard(notified_user,current_site).find(:first)
    assert_equal group.id, act.group.id

    act = GroupGainedUserActivity.for_group(group, notified_user).find(:first, :order => 'created_at DESC')
    assert_equal GroupGainedUserActivity, act.class
    assert_equal group.id, act.group.id

    # users own activity should always show up:
    act = UserJoinedGroupActivity.for_dashboard(user,current_site).find(:first)
    assert_equal group.id, act.group.id
    # user is not on current_site.
    assert_nil UserJoinedGroupActivity.for_dashboard(notified_user,current_site).find(:first)
  end


  def test_deleted_subject
    u1 = users(:kangaroo)
    u2 = users(:iguana)

    u1.add_contact!(u2)
    act = FriendActivity.for_dashboard(u1,current_site).find(:first)
    u2.destroy

    assert_equal nil, act.other_user
    assert_equal 'iguana', act.other_user_name
    assert_equal '<span class="user">iguana</span>', act.user_span(:other_user)
  end

  def test_associations
    assert check_associations(Activity)
  end

  def test_message_page
    u1 = users(:kangaroo)
    u2 = users(:iguana)

    @page = Page.make :private_message, :to => [u2], :from => u1, :title => "testing message_page activity", :body => "test message body"

    act = MessagePageActivity.for_dashboard(u2,current_site).find(:first)
    assert_equal u2, act.user
    assert_equal u1, act.other_user
    assert_equal @page.id, act.message_id
  end

end

