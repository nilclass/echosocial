module Admin::RestrictionsPermission
  def may_configure_restrictions?
    may_admin_site?
  end
end
