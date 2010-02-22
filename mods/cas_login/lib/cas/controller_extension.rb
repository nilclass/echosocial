module CAS::ControllerExtension
  def self.included(base)
    base.instance_eval do
      before_filter :check_for_cas_ticket
    end
  end

  # FIXME: there has to be some way to do this in the routes!
  def check_for_cas_ticket
    return unless respond_to?(:current_site) && current_site && current_site.cas_auth?
    if params[:ticket] && params[:ticket] =~ /^ST-/
      redirect_to params.merge(:controller => 'account', :action => 'login')
    end
  end
end
