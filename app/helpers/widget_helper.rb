module WidgetHelper
  def _widget_tree(widget)
    if (subtree = widget.children.map { |child|
          content_tag(:li, _widget_tree(child)) }).any?
      widget_tree_link(widget) + content_tag(:ul, subtree.join)
    else
      widget_tree_link(widget)
    end
  end

  def widget_tree_link(widget)
    spinner(spinner_id = "widget_tree-#{widget.id}")+
      link_to_remote(widget.display_name, :url => {
                       :controller => 'widget',
                       :action => 'load_form',
                       :id => widget.id
                     },
                     :loading => show_spinner(spinner_id),
                     :loaded => hide_spinner(spinner_id))
  end

  def widget_tree(root)
    content_tag(:ul, content_tag(:li, _widget_tree(root)))
  end
end
