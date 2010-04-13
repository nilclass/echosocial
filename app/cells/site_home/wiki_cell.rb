class SiteHome::WikiCell < BaseCell
  def show
    @group = current_site.network
    render
  end
end
