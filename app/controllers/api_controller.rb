class ApiController < ApplicationController
  def law
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>relation.select(%w(id title brief category))
  end

  def freelaw
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>relation.select(%w(id title brief category))
  end

  def law_eps
  	render :json=> Law.find(params[:id]).exampoints.select('id,title')
  end

  def ep_questions
  	render :json=> Exampoint.find(params[:id]).questions
  end

  def epmenus
  	arr = []

  	Epmenu.roots.select(%w(id title ancestry)).each do |root|
			root_arr = root.attributes
			root_arr[:children] = []
			root.children.select(%w(id title)).each do |child|
				root_arr[:children].push child.attributes
			end
  		arr.push root_arr
  	end
  	render :json=>arr
  end

  def epquestions

  end
end
