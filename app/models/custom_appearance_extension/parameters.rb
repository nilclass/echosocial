module CustomAppearanceExtension
  module Parameters
    # how tall can the masthead image be
    MASTHEAD_IMAGE_MAX_WIDTH = 800
    # [W, H]
    FAVICON_DIMENSIONS = [[16, 16], [32, 32]]

    def self.included(base)
      base.extend ClassMethods
    end

    def delete_bad_parameters
      parameters.delete_if {|k, v| v.nil? || v.empty?}
    end

    def masthead_asset_uploaded_data
      masthead_asset.url if masthead_asset
    end

    def masthead_asset_uploaded_data=(data)
      return if data == ""
      begin
        asset = Asset.create_from_params!({:uploaded_data => data})
        if !asset.is_image
          self.errors.add_to_base(I18n.t(:not_an_image_error))
        elsif !asset.height
          self.errors.add_to_base(I18n.t(:cant_detect_image_height_error))
        elsif asset.width != MASTHEAD_IMAGE_MAX_WIDTH
          self.errors.add_to_base(I18n.t(:too_wide_image_error, :count => MASTHEAD_IMAGE_MAX_WIDTH))
        else
          # all good
          # delete the old masthead asset
          self.masthead_asset.destroy if self.masthead_asset
          self.masthead_asset = asset
        end
      rescue ActiveRecord::RecordInvalid => exc
        self.errors.add_to_base(exc.message)
      end

      unless self.errors.empty?
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end

    def favicon_uploaded_data
      favicon.url if favicon
    end

    def favicon_uploaded_data=(data)
      return if data == ""
      begin
        asset = Asset.create_from_params!({:uploaded_data => data})
        if !asset.is_image
          self.errors.add_to_base(I18n.t(:not_a_favicon_image_error))
        elsif !asset.height or !asset.width
          self.errors.add_to_base(I18n.t(:cant_detect_image_height_error))
        elsif !FAVICON_DIMENSIONS.include?([asset.width, asset.height])
          self.errors.add_to_base(I18n.t(:favicon_image_bad_dimensions_error))
        else
          # all good
          # delete the old masthead asset
          self.favicon.destroy if self.favicon
          self.favicon = asset
        end
      rescue ActiveRecord::RecordInvalid => exc
        self.errors.add_to_base(exc.message)
      end

      unless self.errors.empty?
        raise ActiveRecord::RecordInvalid.new(self)
      end
    end

    def masthead_background_parameter
      background = self.parameters['masthead_background'] || CustomAppearance.available_parameters['masthead_background']
      background = 'white' if !background || background.empty?
      background.gsub /^#/, ""
    end

    def masthead_background_parameter=(value)
      # hopefully we won't run into color names that match this criteria
      if value.size == 3 or value.size == 6
        if value.upcase =~ /^([A-F0-9])+$/
          # add the color #
          value = "#" + value
        end
      end

      self.parameters['masthead_background'] = value.any? ? value : 'white'
    end

    def masthead_enabled
      display = self.parameters['masthead_display'] || CustomAppearance.available_parameters['masthead_display']
      if display =~ /none/ or !display
        # display is set to none or is not set at all
        false
      else
        true
      end
    end

    def masthead_enabled=(value)
      display = 'none'
      if value =~ /block|inline|table|none/
        # setting the direct css display property
        display = value
      elsif value == "0"
        display = 'none'
      else
        # is value something positive?
        display = (value ? 'block' : 'none')
      end
      self.parameters['masthead_display'] = display
    end

    def smart_parameters=(params)
      params.each_pair do |key, value|
        self.parameters[key] = if value.nil?
                                 nil
                               elsif value.kind_of?(String)
                                 value
                               elsif value.kind_of?(Hash)
                                 case self.class.parameter_type(key).to_sym
                                 when :border
                                   [value[:style], value[:size], value[:color]].join(' ')
                                 when :size
                                   [value[:value], value[:unit]].join
                                 when :margin
                                   [value[:top], value[:right], value[:bottom], value[:left]].compact.join(' ')
                                 when :padding
                                   [value[:top], value[:right], value[:bottom], value[:left]].compact.join(' ')
                                 when :image
                                   "url(#{value[:url]})"
                                 else
                                   logger.fatal("Unhandled CA parameter: #{key.inspect} -> #{value.inspect}")
                                 end
                               end
      end
    end

    # builds a hash based object with a object-like interface that contains all available parameters
    # as objects descended from CustomAppearance::Parameter::Base. These parameter objects can be used
    # in conjunction with the Rails FormBuilder (and they are, in the colortheme editor).
    def smart_parameters
      self.class.available_parameters(true).each_pair.inject(CustomAppearance::Parameter::Parameters.new) do |params, (key, spec)|
        default = spec[:default]
        type = spec[:type]
        value = (self.parameters[key.to_s] || default)
        if klass = CustomAppearance::Parameter.for(type)
          params[key] = value ? klass.parse(value) : klass.new
        else
          params[key] = value
        end
        next(params)
      end
    end

    protected

    module ClassMethods
      def available_parameters(include_types=false)
        @available_parameters ||= { }
        return @available_parameters[include_types] if @available_parameters[include_types]
        parameters = {}
        # parse the constants.sass file and return the hash
        constants_lines = File.readlines(File.join(CustomAppearance::SASS_ROOT, CustomAppearance::CONSTANTS_FILENAME))
        constants_lines.reject! {|l| l !~ /^\s*!\w+/ }
        constants_lines.each do |l|
          k, v = l.chomp.split(/\s*=\s*/)
          k[/^!/] = ""
          type = nil
          # types are given as comments. see note in constants.sass for details.
          if md = v.match(%r[^(.*?)//(.*)$])
            v, type = md[1..2]
            if md = type.match(/type:\s*(\w+)/)
              type = md[1]
            else
              type = 'default'
            end
          end
          parameters[k] = include_types ? { :default => v, :type => type } : v
        end
        @available_parameters[include_types] = parameters
      end

      def valid_parameter_types
        %w(default border size margin padding color image display font)
      end

      def parameter_type(key)
        available_parameters(true)[key]
      end
    end
  end
end
