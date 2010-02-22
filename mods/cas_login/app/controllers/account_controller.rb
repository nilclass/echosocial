class AccountController < ApplicationController
  include CAS::AccountControllerExtension unless included_modules.include?(CAS::AccountControllerExtension)
end
