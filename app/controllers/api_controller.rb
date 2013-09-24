class ApiController < ApplicationController

  def current_user
    User.first
  end  
  # 收藏真题
  def collect_question
    Collect.add(current_user,Question.find(params[:id]))
    render_success
  end

  # 收藏免费法条
  def collect_freelaw
    Collect.add(current_user,Freelaw.find(params[:id]))
    render_success
  end

  #收藏法条
  def collect_law
    Collect.add(current_user,Law.find(params[:id]))
    render_success
  end

  # 取消收藏真题
  def uncollect_question
    Collect.remove(current_user,Question.find(params[:id]))
    render_success
  end

  # 取消收藏免费法条
  def uncollect_freelaw
    Collect.remove(current_user,Freelaw.find(params[:id]))
    render_success
  end

  # 取消收藏法条
  def uncollect_law
    Collect.remove(current_user,Law.find(params[:id]))
    render_success
  end

  # 已收藏法条
  def collected_law
    if params[:id] == nil
      relation = Collect.roots current_user, Law
    else
      relation = Collect.children current_user , Law.find(params[:id])
    end
    render :json=>relation.select(%w(id title brief category blanks sound))
  end

  # 已收藏免费法条
  def collected_freelaw

  end

  #法条班法条  
  def law
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>relation.select(%w(id title brief category blanks sound))
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

  def law_blanks
    render :json=>Law.find(params[:id]).blanks
    # law = 
    # blanks = []
    # if law.ancestry_depth == 3
    #   blanks = law.blanks
    # else
    #   law.subtree.each do |i|
    #     blanks = blanks | i.blanks
    #   end
    # end
    
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
  	render :json=> Exampoint.find(params[:id]).questions.to_json(:include=>{
      :eps=>{:only=>[:id,:title]},
    })
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
    questions = R.new.rand_questions_by_epm(Epmenu.find(params[:id]),params[:limit].to_i)
  	render :json=>Question.where(:id=>questions.collect{|i|i.id}).to_json(:include=>{
      :eps=>{:only=>[:id,:title]},
    })
  end

  # 随机输入  
  def rapid_questions
    questions = R.new.rand_questions_by_epms(Epmenu.roots.where('volumn'=>params[:volumn]),params[:limit].to_i)
    render :json=>Question.where(:id=>questions.collect{|i|i.id}).to_json(:include=>{
      :eps=>{:only=>[:id,:title]},
    })
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

  def answer_questions    
    if params[:data].class == Array
      params[:data] = Hash[(0...params[:data].size).zip params[:data]]
    end

    params[:data].each_pair do |_,item|
      History.log(current_user.id,item[:id],item[:myAnswer])
    end
    render_success
  end

  def collected_epmenus
    collects = Collect.where(:user_id=>current_user.id,:collectable_type=>Question.to_s)
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
