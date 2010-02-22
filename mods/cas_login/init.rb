self.load_once = false

gem 'rubycas-client', "=2.1.0git171ccef"
require 'casclient'
require 'casclient/frameworks/rails/filter'

Dispatcher.to_prepare do
  ModSetting.register(:mod => 'cas_login',
                      :name => :cas_auth,
                      :type => :boolean,
                      :label => "Use CAS Authentication",
                      :description => "If enabled, authentication will be performed via a CAS Server instead of the builtin authentication system.")
  ModSetting.register(:mod => 'cas_login',
                      :name => :cas_base_url,
                      :type => :string,
                      :label => "CAS Base URL",
                      :description => "Base URL of the CAS Server to use for authentication.")

  ActionController::Base.send(:include, CAS::ControllerExtension)

  # by default a successful login with no corresponding local user is an error.
  CAS::Hook.register(:create_user) do |login|
    if User.find_by_login(login)
      raise "User #{login} exists, but wasn't logged in for some reason."
    else
      raise "No such user: #{login}"
    end
  end
end
