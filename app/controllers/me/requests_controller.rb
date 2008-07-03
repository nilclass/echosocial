#
# my requests:
#  my contact requests
#  my membership requests
#
# contact requests:
#   from other to me
#
# membership requests:
#   from other to groups i am admin of
#

class Me::RequestsController < Me::BaseController

  def index
    path = ['descending', 'created_at', 'limit', '20']
    @my_pages, @my_sections, @my_columns = my_req_list(path.dup)
    @contact_pages, @contact_sections, @contact_columns = contact_req_list(path.dup)
    @membership_pages, @membership_sections, @membership_columns = membership_req_list(path.dup)
  end

  def mine
    @pages, @sections, @columns = my_req_list(params[:path])
    render :action => 'more'
  end
  
  def contacts
    @pages, @sections, @columns = contact_req_list(params[:path])
    render :action => 'more'
  end

  def memberships
    @pages, @sections, @columns = membership_req_list(params[:path])
    render :action => 'more'
  end

  def more
  end
  
  protected

  def my_req_list(path=[])
    path << 'created_by' << current_user.id
    options = options_for_me(:flow => [:contacts,:membership])
    pages, page_sections = Page.find_and_paginate_by_path(path, options)
    columns = [:title, :created_at, :contributors_count]
    [pages, page_sections, columns]
  end
  
  def contact_req_list(path=[])
    path << 'not_created_by' << current_user.id << 'type' << 'request'
    options = options_for_me(:flow => :contacts)
    pages, page_sections = Page.find_and_paginate_by_path(path, options)
    columns = [:title, :discuss, :created_by, :created_at, :contributors_count]
    [pages, page_sections, columns]
  end

  def membership_req_list(path=[])
    path << 'not_created_by' << current_user.id << 'type' << 'request'
    options = options_for_me(:flow => :membership)
    pages, page_sections = Page.find_and_paginate_by_path(path, options)
    columns = [:title, :group, :discuss, :created_by, :created_at, :contributors_count]
    [pages, page_sections, columns]
  end

  def context
    me_context('small')
    add_context 'requests', url_for(:controller => 'me/requests', :action => nil)
    add_context params[:action], url_for(:controller => 'me/requests') unless (params[:action] == 'index' || params[:action] == nil)
  end
  
end
