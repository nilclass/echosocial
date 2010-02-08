require File.dirname(__FILE__) + '/../test_helper'

class SiteDomainsTest < ActiveSupport::TestCase
  fixtures :sites

  # fixtures from mods don't seem to work. doing it this way for now...
  def setup
    SiteDomain.all.map(&:destroy)
    @domains = []
    @domains << SiteDomain.create!(:domain => 'multiple-test.localhost', :site_id => Site.find(1).id)
    @domains << SiteDomain.create!(:domain => 'xyz.localhost', :site_id => Site.find(1).id)
    @domains << SiteDomain.create!(:domain => 'test.example', :site_id => Site.find(2).id)
  end

  def test_should_find_sites
    @domains.each do |domain|
      assert (site = Site.for_domain(domain.domain).first) == domain.site
      assert site.domains.include?(domain.domain)
    end
  end

  def test_should_find_no_site
    assert Site.for_domain('no.such.domain').empty?
  end
end
