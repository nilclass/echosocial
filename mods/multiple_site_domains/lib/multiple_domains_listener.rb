class MultipleDomainsListener < Crabgrass::Hook::ViewListener
  def admin_nav(context)
    link_to("Domains", admin_site_domains_url)
  end
end
