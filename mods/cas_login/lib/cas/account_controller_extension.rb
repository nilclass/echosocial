module CAS::AccountControllerExtension
  def self.included(base)
    base.instance_eval do
      alias_method_chain :login, :cas
      alias_method_chain :logout, :cas
      alias_method_chain :redirect_to, :cas
      skip_filter :check_for_cas_ticket
    end
  end

  def logout_with_cas
    if current_site.cas_auth?
      configure_cas!
      @dont_redirect = true
      logout_without_cas
      @dont_redirect = false
      CASClient::Frameworks::Rails::Filter.logout(self, url_for(:controller => 'root')) if current_site.cas_auth?
    else
      logout_without_cas
    end
  end

  def login_with_cas
    unless current_site.cas_auth?
      login_without_cas
      return
    end
    logger.info("Logging in with CAS")
    configure_cas!
    previous_language = session[:language_code]
    reset_session
    session[:language_code] = previous_language
    CASClient::Frameworks::Rails::Filter.filter(self)
    if session[:cas_user]
      logger.debug("Trying to login as '#{session[:cas_user]}'...")
      self.current_user = User.find_by_login(session[:cas_user])

      unless logged_in?
        CAS::Hook.call(:create_user, session[:cas_user])
      end

      if current_user.language.any?
        session[:language_code] = current_user.language.to_sym
      else
        session[:language_code] = previous_language
      end

      current_site.add_user!(current_user)
      UnreadActivity.create(:user => current_user)

      redirect_successful_login
    end
  end

  private

  def configure_cas!
    CASClient::Frameworks::Rails::Filter.configure :cas_base_url => current_site.cas_base_url
  end

  def redirect_to_with_cas(*args)
    @dont_redirect ? (@last_redirect_args = args) : redirect_to_without_cas(*args)
  end
end
