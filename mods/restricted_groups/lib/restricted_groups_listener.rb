class RestrictedGroupsListener < Crabgrass::Hook::ViewListener
  def admin_nav(context)
    content_tag(:ul, content_tag(:li, link_to("Group / Network Restrictions", admin_configure_restrictions_url)))
  end
end
