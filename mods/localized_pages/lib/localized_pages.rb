module LocalizedPages
  module PageExtension
    def self.included(base)
      base.instance_eval do 
        cattr_accessor :current_language_code
        extend ClassMethods
        
        named_scope :with_language_code, lambda { |code|
          { :conditions => { :language_code => code } }
        }
        
        before_save :set_language_code
        class << base
          alias_method_chain :find, :localized_pages
        end
      end
    end
    
    def set_language_code
      if code = self.class.current_language_code
        write_attribute(:language_code, code)
      end
    end

    module ClassMethods
      def find_with_localized_pages(*args)
        if(code = current_language_code)
          with_language_code(code).find_without_localized_pages(*args)
        else
          find_without_localized_pages(*args)
        end
      end
    end
  end
  
  module ControllerExtension
    def self.included(base)
      base.instance_eval do
        before_filter :set_language_code_for_pages
      end
    end
    
    def set_language_code_for_pages
      set_language unless session[:language_code]
      if code = session[:language_code]
        Page.current_language_code = code.to_s
      end
    rescue NameError
      # some controllers (e.g. StaticController) don't have set_language defined
    end
  end
end
