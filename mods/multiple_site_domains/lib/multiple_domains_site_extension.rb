module MultipleDomainsSiteExtension
  def self.included(base)
    base.instance_eval do
      has_many :site_domains

      named_scope :for_domain, lambda { |domain|
        # I tried to use a INNER JOIN instead, but it would return an invalid site record (referencing the SiteDomain's id instead of the one of the Site)
        domain_query = '(sites.domain = ? OR sites.id IN (SELECT site_id FROM site_domains WHERE site_domains.domain = ?))'
        { :conditions => (Conf.dynamic_sites ?
                          ["#{domain_query} AND sites.enabled = ?", domain, domain, true] :
                          ["#{domain_query} AND sites.id IN (?)", domain, domain, Conf.enabled_site_ids])
        }
      }
    end
  end

  def domains
    site_domains.map(&:domain).unshift(domain)
  end
end
