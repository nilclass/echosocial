module PageExtension::Create
  #
  # special magic page create
  #
  # just like a normal activerecord.create, but with some magic options that
  # may optionally be passed in as attributes:
  #
  #  :user -- the user creating the page. they become the creator and owner
  #           of the page.
  #  :share_with -- other people, groups, or emails to share this page with.
  #  :access -- what access to grant them (defaults to :admin)
  #
  # if anything goes wrong, an exception is raised, so watch out.
  # see UserExtension::Sharing#may_share_page_with!
  #
  def self.create(attributes = nil, &block)
     if attributes.is_a?(Array)
       # act like normal create
       super(attributes, &block)
     else
       # extract extra attributes
       user       = attributes.delete(:user)
       recipients = attributes.delete(:share_with)
       access     = attributes.delete(:access) || :admin
       options[:created_by] ||= user
       options[:updated_by] ||= user
       Page.transaction do
         page = new(attributes)
         if user
           # grant user admin access, so that we may share.
           page.user_participations.build(:user_id => user.id, :access => ACCESS[:admin])
           # test sharing before page.save
           user.may_share_page_with!(page, recipients, :access => access)
         end
         yield(page) if block_given?
         page.save
         if user
           # do actual sharing after page.save
           user.share_page_with!(page, recipients, :access => access)
           # remove user's admin access if it is redundant
           user_is_admin_via_group = page.groups_with_access(:admin).detect do |group|
             user.member_of?(group)
           end
           if user_is_admin_via_group
             page.add(user, :access => nil)
           end
         end
       end
       page
     end
  end
   
end

