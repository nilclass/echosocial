class Admin::RestrictionsController < Admin::BaseController
  permissions 'admin/restrictions'
  def configure
    @site = current_site
  end
end
