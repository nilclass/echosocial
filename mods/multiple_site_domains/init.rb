self.load_once = false
self.override_views = true

require 'multiple_domains_listener'

Dispatcher.to_prepare do
  Site.send(:include, MultipleDomainsSiteExtension)
end
