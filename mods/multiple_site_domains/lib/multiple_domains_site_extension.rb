module MultipleDomainsSiteExtension
  def self.included(base)
    base.instance_eval do
      has_many :site_domains

      named_scope :for_domain, lambda { |domain|
        domain_query = '(sites.domain = ? OR site_domains.domain = ?)'
        { :conditions => (Conf.dynamic_sites ?
                          ["#{domain_query} AND sites.enabled = ?", domain, domain, true] :
                          ["#{domain_query} AND sites.id IN (?)", domain, domain, Conf.enabled_site_ids]),
          :joins => :site_domains
        }
      }
    end
  end

  def domains
    site_domains.map(&:domain).unshift(domain)
  end
end
