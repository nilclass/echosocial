class WidgetController < ApplicationController
  permissions 'groups/base'

  before_filter :fetch_widget

  def show
    render :partial => '/common/widget', :locals => { :widget => @widget }, :layout => ! request.xhr?
  end

  def edit
    @admin_widgets = true
  end

  def load_form
    render :update do |page|
      page.replace_html('widget_form', :partial => 'form')
    end
  end

  def save
    success = @widget.update_attributes(params[:widget])
    flash_message_now(:object => @widget)
    render :update do |page|
      page.call('showNoticeMessage', display_messages)
      page.call('load_widget_preview') if success
    end
  end

  protected

  def fetch_widget
    @widget = params[:id] ? Widget.find(params[:id]) : current_site.network.widgets.root
  end
end
