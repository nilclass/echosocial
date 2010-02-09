class MultipleDomainsListener < Crabgrass::Hook::ViewListener
  def admin_nav(context)
    content_tag(:ul, content_tag(:li, link_to("Domains", admin_site_domains_url)))
  end
end
