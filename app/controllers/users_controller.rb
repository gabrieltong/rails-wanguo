class UsersController < ApplicationController
  def index
    @relation = User.where('id>0')
    paginate
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  def edit
  end
end
