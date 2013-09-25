# encoding: UTF-8
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
  def collected_laws
    if params[:id] == nil
      relation = Collect.roots current_user, Law
    else
      relation = Collect.children current_user , Law.find(params[:id])
    end
    render :json=>laws_to_json(relation)
  end


  #法条班法条  
  def laws
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>laws_to_json(relation)
  end


  # 免费法条
  def freelaws
  	if params[:id] == nil
  		relation = Law.roots
  	else
  		relation = Law.find(params[:id]).children
  	end
  	render :json=>freelaws_to_json(relation)
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
  	render :json=> questions_to_json(Exampoint.find(params[:id]).questions)
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
    questions = Question.where(:id=>questions.collect{|i|i.id})
  	render :json=>questions_to_json(questions)
  end

  # 随机输入  
  def rapid_questions
    questions = R.new.rand_questions_by_epms(Epmenu.roots.where('volumn'=>params[:volumn]),params[:limit].to_i)
    questions = Question.where(:id=>questions.collect{|i|i.id})
    render :json=>questions_to_json(questions)
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
    questions = Question.where(:id=>histories.collect{|i|i.question_id})
    render :json=>questions_to_json(questions)
  end

  def mistake_questions_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    questions = Question.where(:id=>histories.collect{|i|i.question_id})
    render :json=>questions_to_json(questions)
  end

  # 基于收藏真题查找收藏部门法
  def collected_epmenus
    render :json=>Collect.roots(current_user,'Question').select(%w(id title))
  end

  # 通过收藏部门法查找考点
  def collected_eps_by_epmenu
    render :json=>Collect.children(current_user,Epmenu.find(params[:id])).select(%w(id title))
  end

  # 通过收藏考点查找真题
  def collected_questions_by_ep
    questions = Collect.children(current_user,Exampoint.find(params[:id]))
    render :json=>questions_to_json(questions)
  end

  # 基于收藏真题查找收藏知识点
  def collected_eps
    render :json=>Collect.roots(current_user,'QuestionEp').select(%w(id title))
  end  

  def collected_questions_by_epmenu

  end

  # 搜索法条
  def search_laws
    who = current_user
    action = :validate_law_roots
    if params[:id]
      searchable = Law.find(params[:id]) 
    else
      searchable = Law
    end
    keyword = params[:keyword]

    render :json=>laws_to_json(Search.search(who,action,searchable,keyword))
  end

  #搜索免费法条
  def search_freelaws
    who = current_user
    action = :validate_freelaw_roots
    if params[:id]
      searchable = Freelaw.find(params[:id]) 
    else
      searchable = Freelaw
    end
    keyword = params[:keyword]

    render :json=>freelaws_to_json(Search.search(who,action,searchable,keyword))
  end

  # 发送开始心跳
  def heartbeat_start
    Heartbeat.start(current_user)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  # 发送心跳
  def heartbeat_beat
    Heartbeat.beat(current_user)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  # 发送停止心跳
  def heartbeat_stop
    Heartbeat.stop(current_user)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  private

  def questions_to_json(questions)
    questions.each do |question|
      question.current_user = current_user
    end
    questions.to_json(
      :include=>{
        :eps=>{:only=>[:id,:title]},
      },
      :methods=>[:is_collected]
    )
  end

  def laws_to_json(laws)
    relation.select(%w(id title brief category blanks sound))
  end

  def freelaws_to_json(freelaws)
    relation.select(%w(id title brief category))
  end
end

