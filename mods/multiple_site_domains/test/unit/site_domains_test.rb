require File.dirname(__FILE__) + '/../test_helper'

class SiteDomainsTest < ActiveSupport::TestCase
  fixtures :sites

  # fixtures from mods don't seem to work. doing it this way for now...
  def setup
    SiteDomain.all.map(&:destroy)
    @domains = []
    @domains << SiteDomain.create!(:domain => 'multiple-test.localhost', :site_id => Site.all[0])
    @domains << SiteDomain.create!(:domain => 'xyz.localhost', :site_id => Site.all[0])
    @domains << SiteDomain.create!(:domain => 'test.example', :site_id => Site.all[1])
    $stderr.puts("ALL SITES:\n"+Site.all.inspect)
  end

  def test_should_find_sites
    @domains.each do |domain|
      site = Site.for_domain(domain.domain).first
      $stderr.puts "site for #{domain.domain} is #{site.inspect}"
      assert site == domain.site
    end
  end

  def test_should_find_no_site
    assert Site.for_domain('no.such.domain').empty?
  end
end
