class ApplicationController < ActionController::Base
  include Clearance::Controller
  include Clearance::HttpAuth
  protect_from_forgery
  
  def authenticate(params)
    User.authenticate(params[:session][:username],
                      params[:session][:password])
  end

  def sign_in(user)
    user.reset_remember_token! if user
    super
  end

  def render_success(msg=nil)
    render json: {:result=>:success,:msg=>msg}
  end

  def render_fail(msg=nil)
    render json: {:result=>:fail,:msg=>msg}
  end  
end
