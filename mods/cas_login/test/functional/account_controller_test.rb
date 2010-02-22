require File.dirname(__FILE__) + '/../test_helper'

class AccountControllerTest < ActionController::TestCase
  fixtures :sites, :users

  def setup
    Conf.enable_site_testing('site2')
  end

  def test_login_with_cas_should_succeed
    enable_cas_auth
    fake_as(:blue)
    get :login
    assert session[:user]
    assert_response :redirect
  end

  def test_login_with_cas_should_call_hook
    enable_cas_auth
    CAS::Hook.register(:create_user) do |login|
      @new_user_would_be = login
    end
    fake_as(:non_existant_user)
    get :login
    assert_equal @new_user_would_be.to_s, 'non_existant_user'
  end

  def test_login_without_cas_should_succeed
    disable_cas_auth
    get :login
    assert_response :success

    post :login, :login => 'quentin', :password => 'quentin'
    assert session[:user]
    assert_response :redirect
  end

  def test_login_without_cas_should_fail
    disable_cas_auth
    post :login, :login => 'quentin', :password => 'bad password'
    assert_nil session[:user]
    assert_response :success
  end

  private

  def enable_cas_auth
    @site = Site.find_by_name('site2')
    @site.update_attributes!(:cas_auth => true, :cas_base_url => 'http://test.host/')
  end

  def disable_cas_auth
    @site = Site.find_by_name('site2')
    @site.update_attributes!(:cas_auth => false, :cas_base_url => 'http://test.host')
  end

  def fake_as(user)
    CASClient::Frameworks::Rails::Filter.fake(user.to_s)
  end
end
