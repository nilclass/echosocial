module PublicFacingLayout

  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
    base.instance_eval do
      alias_method_chain :choose_layout, :public_facing
    end
  end 
  
  module InstanceMethods
    
    def choose_layout_with_public_facing
      #set layout dir to public_facing if user is not logged_in
      logged_in? ? layout_dir = '' : layout_dir = 'public_facing/'
      #we don't need to add the dir to the default layout in this case,
      #page creation needs the user to be logged in
      return 'default' if params[:action] == 'create'
      return layout_dir+'page'
    end
    
  end

end
