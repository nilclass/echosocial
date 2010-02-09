module GroupsPermissionExtension
  def self.included(base)
    base.instance_eval do
      alias_method_chain :may_create_network?, :restrictions
      alias_method_chain :may_create_group?, :restrictions
    end
  end

  def may_create_network_with_restrictions?
    (current_site.network_creation_restricted ? current_user.may?(:admin, current_site) : true) and may_create_network_without_restrictions?
  end

  def may_create_group_with_restrictions?
    $stderr.puts "This is the overridden may_create_group? method"
    (current_site.group_creation_restricted ? current_user.may?(:admin, current_site) : true) and may_create_group_without_restrictions?
  end
end
