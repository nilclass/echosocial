class WidgetController < ApplicationController
  permissions 'groups/base'

  before_filter :fetch_widget, :except => [:add]

  def show
    render :partial => '/common/widget', :locals => { :widget => @widget }, :layout => ! request.xhr?
  end

  def edit
    @root = (@widget.root || current_site.widgets.root)
    @admin_widgets = true
  end

  def load_form
    update_ui!
  end

  def add
    @parent = Widget.find(params[:parent_id])
    @widget = Widget.create(params[:widget].merge(:network => @parent.network))
    @widget.move_to_child_of(@parent)
    flash_message_now(:object => @widget)
    update_ui!
  end

  def remove
    parent = Widget.find(@widget.parent_id)
    @widget.destroy
    @widget = parent
    update_ui!
  end

  def save
    success = @widget.update_attributes(params[:widget])
    flash_message_now(:object => @widget)
    update_ui!
  end

  protected

  def update_ui!
    @root = (@widget.try(:root) || current_site.widgets.root)
    render :update do |page|
      page.call('showNoticeMessage', display_messages)
      page.call('load_widget_preview')
      page.replace_html 'widget_tree', :partial => 'widget_tree'
      page.replace_html('widget_form', :partial => 'form')
    end
  end

  def fetch_widget
    @widget = params[:id] ? Widget.find(params[:id]) : current_site.network.widgets.root
    unless @widget
      # setup default root widget if there is none.
      @widget = current_site.network.widgets.create!(:direction => :horizontal)
    end
  end
end
