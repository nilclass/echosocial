=begin

this helper is available to all page controllers derived from
BasePageController

=end

module BasePageHelper

  def header_for_page_create(page_class)
    %Q[
    <div class='page-class'>
      <span class='page-link' style='background: url(/images/pages/big/#{page_class.icon}) no-repeat 0% 50%'><b>#{page_class.class_display_name.t}</b>: #{page_class.class_description.t}</span>
    </div>
    ]
  end

  def return_to_page(page)
    '<p>' + 
    link_to('&laquo; return to <b>%s</b>' % @page.title, page_url(@page)) +
    "</p>\n"
  end
  
  def show_notify_function
    remote_function(:url => pages_url(@page, :action=>'show_notify_form'))
  end
  
  def show_notify_click
    %Q[ $('notify_area').toggle(); if ($('page_notify_form')==null) {#{show_notify_function};} ]
  end

  
end