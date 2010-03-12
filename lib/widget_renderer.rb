class WidgetRenderer
  def initialize(controller)
    @controller = controller
  end

  def render(widget)
    render_frame(widget) do
      if widget.empty?
        render_empty(widget)
      else
        @controller.render_cell(widget.cell_name, widget.initial_state)
      end
    end
  end

  def render_frame(widget, &block)
    %Q{<div class="#{widget.css_classes.join(' ')}">#{block.call}</div>}
  end

  def render_empty(widget)
    widget.children.map do |child|
      render(child)
    end
  end
end
