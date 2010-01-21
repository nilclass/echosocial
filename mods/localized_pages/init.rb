
require 'localized_pages'

ActionController::Dispatcher.to_prepare do 
  Page.send(:include, LocalizedPages::ModelExtension)
  MenuItem.send(:include, LocalizedPages::ModelExtension)
  
  ActionController::Base.send(:include, LocalizedPages::ControllerExtension)
end
