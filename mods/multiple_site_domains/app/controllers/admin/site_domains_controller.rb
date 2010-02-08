class Admin::SiteDomainsController < Admin::BaseController
  permissions 'admin/site_domains'

  def index
    @site_domains = SiteDomain.find(:all)
  end

  def new
    @site_domain = SiteDomain.new
  end

  def create
    @site_domain = SiteDomain.new(params[:site_domain])
    @site_domain.site = current_site
    if @site_domain.save
      flash[:notice] = "Successfully added Domain '#{@site_domain.domain}' to the current site."
      redirect_to :action => 'index'
    else
      flash[:error] = @site_domain.errors.join("\n")
      render :action => 'new'
    end
  end

  def destroy
    @site_domain = SiteDomain.find(params[:id])
    @site_domain.destroy

    redirect_to :action => 'index'
  end
end
