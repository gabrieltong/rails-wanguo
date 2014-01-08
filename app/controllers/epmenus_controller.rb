class EpmenusController < ApplicationController
  def index
    @relation = Epmenu.roots
    @collection = @relation
  end

  def show
    
  end
end
