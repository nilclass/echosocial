
require 'localized_pages'

ActionController::Dispatcher.to_prepare do 
  Page.send(:include, LocalizedPages::PageExtension)
  load(File.join(RAILS_ROOT, 'app', 'controllers', 'application.rb'))
  ActionController::Base.send(:include, LocalizedPages::ControllerExtension)
end
