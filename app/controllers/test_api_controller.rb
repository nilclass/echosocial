class TestApiController < WebServiceController
 
  skip_filter  :essential_initialization, :set_language, :set_timezone, :pre_clean, :header_hack_for_ie6, :redirect_unverified_user, :context_if_appropriate

  
  include WikiPageHelper
  include UrlHelper
  protect_from_forgery :secret => Conf.secret
  allow_forgery_protection
  
  def get_users_for_group(group,methods)
    #group = Group.find_by_name(group)
    #simpliness ;)
    User.all.map do |user|
      {:display_name => user.display_name, :avatar => avatar_url_for(user)}
    end
  end

  def get_page(page_id)
    #group = Group.find_by_name(group)
    #simpliness ;)
    p = Page.find(page_id)
    { :title => p.title, :content => wiki_body_html(p.wiki)}
  end
  
  def get_random_image_from_gallery(title)
    g = Gallery.find_by_title(title)
    g.images.first(:order => 'rand()').thumbnail(:medium).url 
  end
  
  def get_full_image(thumbnail_url)
    filename = url_to_filename(thumbnail_url)
    Thumbnail.find_by_filename(filename).parent.url
  end
  
  def get_pages_for_group(group)
    if group = Group.find_by_name(group)
      group.pages.find_all_by_public_and_type(true,'WikiPage').map do |page|
        {:id => page.id, :title => page.title} 
      end
    end
  end
  
  private
  
  #Todo - this should be in a helper
  
  def url_to_filename(url)
    url.gsub(/.*\//,'')
  end

end
