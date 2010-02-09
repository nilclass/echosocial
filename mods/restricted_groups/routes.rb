
map.namespace :admin do |admin|
  admin.configure_restrictions '/configure_restrictions', :controller => 'restrictions', :action => 'configure'
end
