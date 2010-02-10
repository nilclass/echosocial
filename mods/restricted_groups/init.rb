self.load_once = false
self.override_views = true

Dispatcher.to_prepare do
  # the check of included_modules is necessary to prevent endless recursion when calling alias_method_chain twice
  MenuHelper.send(:include, MenuHelperExtension) unless MenuHelper.included_modules.include?(MenuHelperExtension)
  Groups::BasePermission.send(:include, GroupsPermissionExtension) unless Groups::BasePermission.included_modules.include?(GroupsPermissionExtension)

  ModSetting.register(:mod => 'restricted_groups',
                      :name => :group_creation_restricted,
                      :type => :boolean,
                      :label => "Only admins can create groups",
                      :description => "Configure who can create a group.")
  ModSetting.register(:mod => 'restricted_groups',
                      :name => :group_tab_visible,
                      :type => :boolean,
                      :label => "Show groups tab",
                      :description => "Show the groups tab in the main menu")
  ModSetting.register(:mod => 'restricted_groups',
                      :name => :network_creation_restricted,
                      :type => :boolean,
                      :label => "Only admins can create networks",
                      :description => "Configure who can create a network.")
  ModSetting.register(:mod => 'restricted_groups',
                      :name => :network_tab_visible,
                      :type => :boolean,
                      :label => "Show networks tab",
                      :description => "Show the networks tab in the main menu")
end
