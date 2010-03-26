class GroupAvatarBoxesCell < AvatarBoxesCell
  def most_active
    @entities = Group.only_groups.most_visits.find(:all, :limit => 15)
    @label = :most_active_groups
    render_state(:display)
  end
end
