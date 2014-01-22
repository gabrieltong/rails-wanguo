class UsersController < ApplicationController
  before_filter :find_user
  skip_before_filter :find_user,:only=>[:index]
    
  # authorize_resource,:only=>[:index,:show]
  # caches_action :index
  def index
    @per_page = 10
    @relation = User.where(true)
    paginate
    
    @collection.each do |user|
      user.auto_cache_setting
    end
  end

  def show
    @user.decorate
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def edit
  end

  def collected_laws
    if params[:law_id] == nil
      @relation = Collect.roots current_user, Law
    else
      @relation = Collect.children current_user , Law.find(params[:id])
    end
    paginate
    render 'laws/index'
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
