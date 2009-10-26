class TestApiController < WebServiceController
 
  skip_filter  :essential_initialization, :set_language, :set_timezone, :pre_clean, :header_hack_for_ie6, :redirect_unverified_user, :context_if_appropriate

  
  include WikiPageHelper
  
  protect_from_forgery :secret => Conf.secret
  allow_forgery_protection
  
  def get_users_for_group(group,methods)
    #group = Group.find_by_name(group)
    #simpliness ;)
    User.all.map do |user|
      {:display_name => user.display_name, :avatar => avatar_url_for(user)}
    end
  end

  def get_page_by_name(name)
    #group = Group.find_by_name(group)
    #simpliness ;)
    p = Page.find_by_name(name)
    page = { :title => p.title, :content => wiki_body_html(p.wiki)}
  end

end
