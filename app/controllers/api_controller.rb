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
    law = Law.find(params[:id])
    exampoints = []
    if law.ancestry_depth == 3
      exampoints = law.exampoints.select('id,title')
    else
      law.subtree.each do |i|
        exampoints = exampoints | i.exampoints.select('id,title')
      end
    end
  	render :json=>exampoints
  end

# 根据知识点返回问题
  def ep_questions
  	render :json=> Exampoint.find(params[:id]).questions
  end

# 返回知识点菜单结构
  def epmenus
    if params[:epmenu_id] == nil
    	render :json=>Epmenu.roots.select(%w(id title))
    else
      render :json=>Epmenu.find(params[:epmenu_id]).children.select(%w(id title))
    end
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

  def answer_question
    History.log(current_user.id,params[:question_id],params[:answer])
    render_success
  end

  def mistake_epmenus
    histories = History.wrong.where(:user_id=>current_user.id)
    list = Epmenu.where(:id=>histories.collect{|i|i.epmenu_id}).select('id,title')
    list = list.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>i.id).select('distinct `question_id`').count()
      attrs[:eps_count] = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>i.id).select('distinct `exampoint_id`').count()
      attrs
    end
    render :json=>list
  end

  def mistake_eps
    histories = History.wrong.where(:user_id=>current_user.id)
    list = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')
    list = list.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').count()
      attrs
    end
    render :json=>list
  end

  def mistake_eps_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    list = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')
    list = list.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').count()
      attrs
    end
    render :json=>list
  end

  def mistake_questions_by_ep
    histories = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>params[:exampoint_id])
    render :json=>Question.where(:id=>histories.collect{|i|i.question_id})
  end

  def mistake_questions_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    render :json=>Question.where(:id=>histories.collect{|i|i.question_id})
  end
end
