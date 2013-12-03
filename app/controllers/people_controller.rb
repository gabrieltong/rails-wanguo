class PeopleController < ApplicationController
  def index
    @relation = User.where('id>0')
    paginate
  end

  def view
  end

  def edit
  end
end
