
Dispatcher.to_prepare do
  Site.send(:include, MultipleDomainsSiteExtension)
end
