module WidgetRendering
  # renders a widget with all it's children (if applicable)
  # I didn't want to call it render_widget, so we don't break
  # apotomo, in case it will be used later on
  def widgets_render(widget)
    logger.debug("rendering widget #{widget.id}")
    widgets_render_frame(widget) do
      if widget.empty?
        widgets_render_empty(widget)
      else
        render_cell(widget.cell_name, widget.initial_state)
      end
    end + include_widgets_css
  end

  # renders the frame of the given +widget+ (which is just a div to handle positioning) wrapped around
  # the return value of the given +block+. If @admin_widgets is set, administrative controls for editing
  # the widget configuration will be rendered as well.
  def widgets_render_frame(widget, &block)
    frame = %Q{<div id="widget_#{widget.id}" class="#{widget.css_classes.join(' ')}">#{block.call}</div>}
    return @admin_widgets ? widgets_render_handle(widget, frame) : frame
  end

  # renders administrative controls for editing the widget configuration, wrapped around the given content.
  def widgets_render_handle(widget, content)
    logger.debug("rendering widget editing controls")
    %Q{<div class="widget_handle_wrapper"><div id="widget_handle_#{widget.id}" class="widget_handle"></div>#{content}</div>}
  end

  # renders an empty widget (including all it's children)
  def widgets_render_empty(widget)
    widget.children.map do |child|
      widgets_render(child)
    end
  end

  # renders the css for widget positioning (by appending it to the :html_head).
  # can be called multiple times, but will only render once.
  def include_widgets_css
    return '' if @widgets_css_rendered
    @widgets_css_rendered = true
    render :partial => '/common/widget_css'
  end
end
