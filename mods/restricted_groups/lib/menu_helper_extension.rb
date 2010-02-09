module MenuHelperExtension
  def self.included(base)
    base.instance_eval do
      alias_method_chain :menu_groups, :restrictions
      alias_method_chain :menu_networks, :restrictions
    end
  end

  def menu_groups_with_restrictions
    current_site.group_tab_visible ? menu_groups_without_restrictions : ''
  end

  def menu_networks_with_restrictions
    current_site.network_tab_visible ? menu_networks_without_restrictions : ''
  end
end
