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
  	render :json=>R.new.rand_questions_by_epm(Epmenu.find(params[:id]),params[:limit].to_i)
  end

  # 随机输入  
  def rapid_questions
    render :json=>R.new.rand_questions_by_epms(Epmenu.roots.where('volumn'=>params[:volumn]),params[:limit].to_i)
  end

  #登录 api
  def login
    if User.authenticate params[:email],params[:password]
      render_success
    else
      render_fail
    end
  end

  def answer_question()
    History.log(current_user,params[:question_id],params[:answer])
  end


end
