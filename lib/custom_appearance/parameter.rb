module CustomAppearance::Parameter
  class Parameters < HashWithIndifferentAccess
    def method_missing(sym, *args)
      if sym.to_s =~ /\=$/
        self[sym] = args.first
      else
        self[sym]
      end
    end
  end

  def self.for(type)
    { :border => CustomAppearance::Parameter::Border,
      :size => CustomAppearance::Parameter::Size,
      :margin => CustomAppearance::Parameter::Margin,
      :padding => CustomAppearance::Parameter::Padding,
      :image => CustomAppearance::Parameter::Image
    }[type.to_sym]
  end

  class Base
    class << self
      def parse(text)
        p = new ; p.parse(text) ; p
      end
      def structure(attr, type)
        self.class_eval %Q{
          def #{attr}=(value)
            @#{attr} = CustomAppearance::Parameter::#{type.to_s.camelize}.parse(value)
          end
        }
      end
    end
  end

  class Border < Base
    attr_accessor :style, :size, :color
    structure :size, :size

    def style_values
      %w(none hidden dotted dashed solid double groove ridge inset outset)
    end

    def parse(text)
      if text
        values = text.split(/\s+/)
        # try to guess the right meaning
        values.each do |val|
          if style_values.include?(val)
            self.style = values.delete(val)
          elsif(val =~ /^#/)
            self.color = values.delete(val)
          elsif val =~ /px$/ || val =~ /em$/ || val =~ /pt$/ || val =~ /%$/
            self.size = values.delete(val)
          end
        end
        # if we still have unassigned values...
        if values.any?
          # ... everyone take what you can get!
          self.style = values.shift unless @style
          self.size = values.shift unless @style
          self.color = values.shift unless @style
        end
      end
    end

    def to_s
      [style, size, color].join(' ')
    end
  end

  class Size < Base
    attr_accessor :value, :unit

    def parse(text)
      if text && md = text.match(/(\d+)(\w+)/)
        self.value, self.unit = *md[1..2]
      end
    end

    def to_s
      [value, unit].join
    end
  end

  class Margin < Base
    attr_accessor :top, :right, :bottom, :left
    structure :top, :size
    structure :right, :size
    structure :bottom, :size
    structure :left, :size

    def parse(text)
      values = text.split(/\s+/)
      if values.size == 4
        self.top, self.right, self.bottom, self.left = *values
      elsif values.size == 2
        self.top = values[0]
        self.bottom = values[0]
        self.left = values[1]
        self.right = values[1]
      elsif values.size == 1
        value = values[0]
        self.top = value
        self.bottom = value
        self.left = value
        self.right = value
      end
    end

    def to_s
      [top, right, bottom, left].join(' ')
    end
  end

  class Padding < Margin
  end

  class Image < Base
    # TODO: support asset id a well?
    attr_accessor :url

    def parse(text)
      self.url = text.match(/url\((.*?)\)/)[1]
    end

    def to_s
      "url(#{@url})"
    end
  end
end
