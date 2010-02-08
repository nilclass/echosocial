module Admin::SiteDomainsPermission
  def may_index_site_domains?
    may_admin_site?
  end

  alias_method :may_new_site_domains?, :may_index_site_domains?
  alias_method :may_create_site_domains?, :may_index_site_domains?
  alias_method :may_destroy_site_domains?, :may_index_site_domains?
end
