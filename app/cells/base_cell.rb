# Common stuff for all cells in crabgrass
class BaseCell < ::Cell::Base
  self.view_paths << File.join(RAILS_ROOT, 'app', 'views')

  helper :all

  delegate :current_site, :to => :controller

  def empty
    ''
  end
end
