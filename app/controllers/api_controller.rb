# encoding: UTF-8
class ApiController < ApplicationController
  # include Clearance::Controller

  before_filter :paginate_params
  before_filter :authorize_token,:except=>[:login,:signup]

  def authorize_token
    @user = User.find_by_remember_token(params[:session][:token])
    render :json=>{:success=>false} unless @user
  end

  def current_user
    @user
  end

  def edit_profile
    if @user.update_attributes(params[:user])
      render :json=>{:success=>true}
    else
      render :json=>{:success=>false,:errors=>@user.errors.full_messages}
    end
  end

  def signup
    @user = user_from_params

    sign_in(@user)
    if @user
      render :json=>{:success=>true,:user=>@user}
    else
      render :json=>{:success=>false,:errors=>@user.errors.full_messages}
    end
  end

  def login
    @user = User.authenticate params[:session][:username],params[:session][:password]
    sign_in(@user)
    if @user
      render :json=>{:success=>true,:user=>@user}
    else
      render :json=>{:success=>false}
    end
  end

  def logout
    
  end


  def mix
    render :json=>{
      :istudy_epmenus_summaries=>Istudy.epmenus_summaries(current_user),
      # :istudy_complex=>Istudy.complex(current_user),
      :istudy_complex_rank=>Istudy.complex_rank(current_user),
      :istudy_xueba=>Istudy.xueba(current_user),      
      :istudy_evaluate=>Istudy.evaluate(current_user),
      :istudy_time=>Heartbeat.duration(Heartbeat.ranges(current_user,current_user))
    }
  end

  # def current_user
  #   User.first
  # end
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
  		@relation = Law.roots
  	else
  		@relation = Law.find(params[:id]).children
  	end
    paginate
  	render :json=>laws_to_json(@collection)
  end


  # 免费法条
  def freelaws
  	if params[:id] == nil
  		@relation = Law.roots
  	else
  		@relation = Law.find(params[:id]).children
  	end
    paginate
  	render :json=>freelaws_to_json(@relation)
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
  # 如果法条是叶子节点 ， 返回改叶子节点的知识点
  # 如果法条不是叶子节点 ， 返回所有子节点的知识点
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
    @relation = Exampoint.where(:id=>exampoints.collect{|ep|ep.id})
    paginate
  	render :json=>@collection
  end

  # 根据知识点返回问题
  def ep_questions
    @relation = Exampoint.find(params[:id]).questions
    paginate
  	render :json=> wrap_questions(@collection)
  end

  # 根据法条返回问题
  def law_questions
    @relation = Law.find(params[:id]).questions
    paginate
    render :json=>wrap_questions(@collection)
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
  	render :json=>wrap_questions(questions)
  end

  # 随机输入  
  def rapid_questions
    questions = R.new.rand_questions_by_epms(Epmenu.roots.where('volumn'=>params[:volumn]),params[:limit].to_i)
    questions = Question.where(:id=>questions.collect{|i|i.id})
    render :json=>wrap_questions(questions)
  end

  # #登录 api
  # def login
  #   if User.authenticate params[:email],params[:password]
  #     render_success
  #   else
  #     render_fail
  #   end
  # end

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
    @relation = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')

    paginate

    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').count()
      attrs
    end
    render :json=>@collection
  end

  def mistake_eps_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    @relation = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')
    paginate
    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').count()
      attrs
    end
    render :json=>@collection
  end

  def mistake_questions_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    @relation = Question.where(:id=>histories.collect{|i|i.question_id})
    paginate
    render :json=>wrap_questions(@collection)
  end

  def mistake_questions_by_ep
    histories = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>params[:exampoint_id])
    @relation = Question.where(:id=>histories.collect{|i|i.question_id})
    paginate
    render :json=>wrap_questions(@collection)
  end

  def mistake_questions_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    @relation = Question.where(:id=>histories.collect{|i|i.question_id})
    paginate
    render :json=>wrap_questions(@collection)
  end

  # 基于收藏真题查找收藏部门法
  def collected_epmenus
    @relation = Collect.roots(current_user,'Question').select(%w(id title))
    paginate
    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = Collect.where(
        :user_id=>current_user.id,
        :collectable_type=>Question.to_s,
        :key1_id=>i.id
      ).select('distinct `collectable_id`').count()

      attrs[:eps_count] = Collect.where(
        :user_id=>current_user.id,
        :collectable_type=>Question.to_s,
        :key1_id=>i.id
      ).select('distinct `key2_id`').count()

      attrs
    end
    render :json=>@collection
  end

  # 通过收藏部门法查找考点
  def collected_eps_by_epmenu
    @relation = Collect.children(current_user,Epmenu.find(params[:id])).select(%w(id title))
    paginate
    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = Collect.where(
        :user_id=>current_user.id,
        :collectable_type=>Question.to_s,
        :key2_id=>i.id
      ).select('distinct `collectable_id`').count()
      attrs
    end
    render :json=>@collection
  end

  # 通过收藏考点查找真题
  def collected_questions_by_ep
    @relation = Collect.children(current_user,Exampoint.find(params[:id]))
    paginate
    render :json=>wrap_questions(@collection)
  end

  # 基于收藏真题查找收藏知识点
  def collected_eps
    @relation = Collect.roots(current_user,'QuestionEp').select(%w(id title))
    paginate
    render :json=>@collection
  end  

  def collected_questions_by_epmenu
    eps =  Collect.children(current_user,Epmenu.find(params[:id]))
    questions = eps.collect do |ep|
      Collect.children(current_user,ep)
    end.flatten.uniq
    @relation = Question.where(:id=>questions.collect{|i|i.id})
    paginate
    render :json=>wrap_questions(@collection)
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
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    Heartbeat.start(current_user,beatable)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  # 发送心跳
  def heartbeat_beat
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    Heartbeat.beat(current_user,beatable)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  # 发送停止心跳
  def heartbeat_stop
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    Heartbeat.stop(current_user,beatable)
    render :json=>{:interval=>Heartbeat::Interval}
  end

  def heartbeat_summary
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = Law
    end

    if params[:from]
      from = Time.zone.parse(params[:from])
    else
      from = Time.zone.parse('2000-01-01 01:00:00')
    end

    if params[:to]
      to = Time.zone.parse(params[:to])
    else
      to = Time.zone.parse('3000-01-01 01:00:00')
    end

    render :json=>Heartbeat.summary(current_user,beatable,from,to)
  end

  def istudy_epmenu_summary
    render :json=>Istudy.epmenu_summary(current_user,params[:type])
  end

  def istudy_epmenus_summaries
    render :json=>Istudy.epmenus_summaries(current_user)
  end

  def istudy_xueba
    render :json=>{:value=>Istudy.xueba(current_user)}
  end

  def istudy_complex
    render :json=>{:value=>Istudy.complex(current_user)}
  end

  def istudy_complex_rank
    render :json=>Istudy.complex_rank(current_user)
  end

  def istudy_evaluate
    render :json=>{:value=>Istudy.evaluate(current_user)}
  end

  def history
    render :json=>{
      :total=>History.by_user(current_user).count(),
      :right=>History.by_user(current_user).right.count(),
      :wrong=>History.by_user(current_user).wrong.count(),
    }
  end

  def history_by_epmenu
    base = History.where(
      :user_id=>current_user.id,
      :epmenu_id=>params[:id]
    )
    render :json=>{
      :total=>base.count(),
      :right=>base.where(:state=>:right).count(),
      :wrong=>base.where(:state=>:wrong).count(),
    }
  end

  def history_by_epmenu_eps
    epmenu = Epmenu.find(params[:id])
    eps = epmenu.exampoints.select(%w(id title))

    base = History.where(
      :user_id=>current_user.id,
      :epmenu_id=>params[:id],
    )

    status = eps.collect do |ep|
      attributes = ep.attributes
      attributes[:total]= base.where(:exampoint_id=>ep.id).count()
      attributes[:right]= base.where(:exampoint_id=>ep.id,:state=>:right).count()
      attributes[:wrong]= base.where(:exampoint_id=>ep.id,:state=>:wrong).count()
      attributes
    end
    render :json=>status
  end

  def history_total_avg_by_epmenu
    base = History.where(
      :epmenu_id=>params[:id]
    )

    total = base.count()
    right = base.where(:state=>:right).count()

    render :json=>{:value=>right*1.0/total*15}
  end

  def history_total_avg_by_epmenu_eps
    epmenu = Epmenu.find(params[:id])

    eps = epmenu.exampoints.select(%w(id title))

    base = History.where(
      :epmenu_id=>params[:id],
    )

    status = eps.collect do |ep|
      attributes = ep.attributes
      total = base.where(:exampoint_id=>ep.id).count()
      right = base.where(:exampoint_id=>ep.id,:state=>:right).count()
      attributes[:value] = right*1.0/total*15
      attributes[:value] = 0 if attributes[:value].nan?
      attributes
    end
    render :json=>status
  end

  private

  # 为问题增加一些属性 ， 例如用户是否收藏，
  def wrap_questions(questions)
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
    if laws.is_a? ActiveRecord::Relation
      laws = laws.select(%w(id title category blanks ancestry_depth sound_file_name sound_content_type sound_file_size sound_updated_at))
    end

    laws.each do |law|
      law.current_user = current_user
    end

    if laws.first && laws.first.ancestry_depth >= 3
      laws.to_json(
        :include=>{:exampoints=>{}},
        :methods=>[:is_collected,:sound_url,:children_state]
      )
    else
      laws.to_json(
        :methods=>[:is_collected,:sound_url,:children_state]
      )
    end
  end

  def freelaws_to_json(freelaws)
    if freelaws.is_a? ActiveRecord::Relation
      freelaws = freelaws.select(%w(id title category))
    end

    freelaws.each do |freelaw|
      freelaw.current_user = current_user
    end

    freelaws.to_json(
      :methods=>[:is_collected,:children_state]
    )
  end

  private 
  # 在返回集合的api上设置分页的页数和分页大小
  # 结果：设置好 @page 和 @per_page
  def paginate_params
    @page = params[:page] || 1 
    @per_page = params[:per_page] || 1000
    @random = params[:random].to_i || 0
  end

  # 根据分页的数量
  # require @page
  # require @per_page
  # set @collection
  def paginate
    if @random == 0
      @collection = @relation.paginate(:page=>@page,:per_page=>@per_page)
    else
      @collection = @relation.random(@per_page)
    end
  end

  def user_from_params
    user_params = params[:user] || Hash.new
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end
end

