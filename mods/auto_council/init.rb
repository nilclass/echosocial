self.load_once = false
self.override_views = true

Dispatcher.to_prepare do
  Group.send(:include, AutoCouncil)
end
