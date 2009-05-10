##
## GreenTree -- a nested tree used for building the outline
##
class GreenTree < Array
  attr_accessor :heading_level
  attr_accessor :tree_level
  attr_accessor :text
  attr_accessor :name

  def initialize(text=nil, name=nil, heading_level=nil)
    tree = super()
    tree.text = text
    tree.heading_level = heading_level
    tree.name = name
    tree
  end

  def inspect
    if leaf?
      %Q["#{text}"]
    else
      %Q["#{text||'root'}" -> [#{self.map{|i|i.inspect}.join(', ')}]]
    end
  end

  alias :to_s :inspect
  alias :leaf? :empty?
  alias :children= :concat
  alias :child :slice
  def children; self; end

  def add_child(txt, name, heading_level)
    self << GreenTree.new(txt, name, heading_level)
  end

  # returns the heading text for the one after the 'heading_name'
  def successor(heading_name)
    children.each_with_index do |node, i|
      if node.name == heading_name
        return child(i+1)
      elsif !node.leaf?
        found = node.successor(heading_name)
        return found unless found.nil? 
      end
    end
    return nil # not found
  end

  # walks tree, looking for a node that matches
  def find(name)
    children.each do |node|
      if node.name == name
        return node
      elsif !node.leaf?
        node = node.find(name)
        return node unless node.nil?
      end
    end
    return nil # not found
  end

  # greencloth specific
  def markup_regexp
    # (\n\r?){0,2}
    /#{Regexp.escape(self.markup)}\s*?(\n\r?\n\r?|$)/
  end

  def markup
    "h%s. %s" % [heading_level, text]
  end

end
