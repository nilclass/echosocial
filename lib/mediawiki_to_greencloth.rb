require 'rubygems'
require 'hpricot'
require 'marker'

module MediaWikiToGreencloth
  def from_media_wiki(input)
    new(media_wiki_to_gc(input))
  end

  def media_wiki_to_gc(mw)
    html_to_gc(media_wiki_to_html(mw))
  end

  def media_wiki_to_html(mw)
    Marker.parse(mw).to_html
  end

  def html_to_gc(input)
    sanitize_gc(Hpricot.parse(input).children.map { |c| _html_to_gc(c) }.join)
  end

  def _html_to_gc(element)
    @list_types ||= []
    @list_depth ||= 0
    if element.kind_of?(String) || element.kind_of?(Hpricot::Text) ## text
      element
    elsif element.kind_of?(Array) ## more elements
      element.map { |e| _html_to_gc(e) }.join
    elsif element.name =~ /(h\d)/ ## headings
      "#{$1}. #{_html_to_gc(element.children)}"
    else ## other elements
      case element.name
      when 'p'
        _html_to_gc(element.children)
      when 'pre'
        element.to_s
      when 'ol'
        @list_types.push '#'
        @list_depth += 1
        ret = _html_to_gc(element.children)
        @list_depth -= 1
        @list_types.pop
        ret
      when 'ul'
        @list_types.push '*'
        @list_depth += 1
        ret = _html_to_gc(element.children)
        @list_depth -= 1
        @list_types.pop
        ret
      when 'li'
        (@list_types.last * @list_depth) + ' ' + _html_to_gc(element.children) + "\n"
      when 'blockquote'
        "\n\nbq. #{_html_to_gc(element.children)}\n\n"
      when 'b'
        "*#{_html_to_gc(element.children)}*"
      when 'i'
        "_#{_html_to_gc(element.children)}_"
      else
        element.to_s
      end
    end
  end

  def sanitize_gc(input)
    # greencloth cannot handle *_xyz_*, but only _*xyz*_
    input.gsub(/\*_(.*?)_\*/, '_*\1*_')
  end
end

GreenCloth.extend(MediaWikiToGreencloth)
