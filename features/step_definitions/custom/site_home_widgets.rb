Given /^the current site has a network$/ do
  @site.network = create_model('network').first
  @site.save!
end

Given /^there are at least "(\d+)" active people in the current site$/ do |count|
  count.to_i.times do
    user = create_model('user').first
    @site.add_user!(user)
    # create a page per user, so the users are actually active
    # (we're using discussion pages, as they don't require data)
    page = DiscussionPage.build!(:share_with => [user], :access => :admin,
                                 :title => "foo-bar", :user => user)
  end
end

Then /^I should see a list of member avatars$/ do
  assert_select('#sidebar')
  assert_select('#main-content-right')
  assert_select('.avatar_small')
end


Given /^the user is member of the current site$/ do
  @site.add_user!(controller.current_user)
end

Given /^the current site network has a summary$/ do
  profile = @site.network.profiles.public
  profile.summary = "This is the summary"
  profile.save!
end

Then /^I should see the summary$/ do
  Then %Q{I should see "#{@site.network.profiles.public.summary}"}
end
