class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Clearance::HttpAuth
  protect_from_forgery

  def sign_in(user)
    user.reset_remember_token! if user
    super
  end
end
