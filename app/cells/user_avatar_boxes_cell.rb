class UserAvatarBoxesCell < AvatarBoxesCell
  def most_active
    @entities = User.most_active_on(current_site, nil).not_inactive.find(:all, :limit => 5)
    @label = :most_active_members
    render_view_for_state(:display)
  end
end
