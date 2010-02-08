class SiteDomain < ActiveRecord::Base
  belongs_to :site

  validates_presence_of :domain
  validates_presence_of :site_id
  validates_uniqueness_of :domain
end
