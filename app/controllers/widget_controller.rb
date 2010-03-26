class WidgetController < ApplicationController
  permissions 'groups/base'

  def show
    @widget = Widget.find(params[:id])
    render :partial => '/common/widget', :locals => { :widget => @widget }, :layout => true
  end

  def edit
    @admin_widgets = true
    show()
  end
end
