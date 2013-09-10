class ApiController < ApplicationController
#法条班法条  
  def law
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>relation.select(%w(id title brief category))
  end


# 免费法条
  def freelaw
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>relation.select(%w(id title brief category))
  end

# 根据法条返回知识点
  def law_eps
  	render :json=> Law.find(params[:id]).exampoints.select('id,title')
  end

# 根据知识点返回问题
  def ep_questions
  	render :json=> Exampoint.find(params[:id]).questions
  end

# 返回知识点菜单结构
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

# 根据知识点菜单结构随机返回题
  def epmenu_questions
  	questions = []
  	eps = Epmenu.find(params[:id]).exampoints.random(params[:limit])
  	eps.each do |ep|
  		questions.push ep.questions.random(1)
  	end
  	questions.flatten!.uniq!

  	if questions.size < params[:limit]
  		
  	end
  	
  	render :json=>questions
  end
end
