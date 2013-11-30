class ApplicationController < ActionController::Base
  include Clearance::Controller
  # include Clearance::HttpAuth
  # protect_from_forgery
  
  before_filter :paginate_params

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

private 
  # 在返回集合的api上设置分页的页数和分页大小
  # 结果：设置好 @page 和 @per_page
  def paginate_params
    @page = params[:page] || 1 
    @per_page = params[:per_page] || 5
    @random = params[:random].to_i || 0
  end

  # 根据分页的数量
  # require @page
  # require @per_page
  # set @collection
  def paginate
    if @random == 0
      @collection = @relation.paginate(:page=>@page,:per_page=>@per_page)
    else
      @collection = @relation.random(@per_page)
    end
  end  
end
