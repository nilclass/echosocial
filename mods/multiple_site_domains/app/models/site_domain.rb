class SiteDomain < ActiveRecord::Base
  belongs_to :site

  validates_uniqueness_of :domain
end
