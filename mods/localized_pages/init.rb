
require 'localized_pages'

ActionController::Dispatcher.to_prepare do
  Page.send(:include, LocalizedPages::ModelExtension) unless Page.included_modules.include?(LocalizedPages::ModelExtension)
  MenuItem.send(:include, LocalizedPages::ModelExtension) unless MenuItem.included_modules.include?(LocalizedPages::ModelExtension)

  ActionController::Base.send(:include, LocalizedPages::ControllerExtension) unless ActionController::Base.included_modules.include?(LocalizedPages::ControllerExtension)

  ModSetting.register(:mod => 'localized_pages',
                      :name => :localized_pages,
                      :type => :boolean,
                      :label => "Localize Pages",
                      :description => "Creates a distinct environment for each language, where people will only see pages in their current language.")
end
