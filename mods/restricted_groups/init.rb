self.load_once = false
self.override_views = true

require 'restricted_groups_listener'

Dispatcher.to_prepare do
  # the check of included_modules is necessary to prevent endless recursion when calling alias_method_chain twice
  MenuHelper.send(:include, MenuHelperExtension) unless MenuHelper.included_modules.include?(MenuHelperExtension)
  Groups::BasePermission.send(:include, GroupsPermissionExtension) unless Groups::BasePermission.included_modules.include?(GroupsPermissionExtension)
end
