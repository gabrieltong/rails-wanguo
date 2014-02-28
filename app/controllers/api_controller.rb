# encoding: UTF-8
class ApiController < ApplicationController
  # include Clearance::Controller

  before_filter :authorize_token,:except=>[:login,:signup,:forget_password,:cities,:schools]

  after_filter :save_dlog

  rescue_from Exception, :with => :server_error

  def cities
    city = params[:city]
    cities = School.group('city').select('city').count.keys
    if cities.include? city
      cities = cities.delete(city).unshift(city)
    else
      cities
    end
    render :json=>cities
  end

  def server_error(exception)
    ExceptionNotifier.notify_exception(exception,
    :env => request.env, :data => {:message => "was doing something wrong"})
    render_fail
  end

  def play_audio
    if Law.find(params[:id]).create_activity key: 'law.play_audio', owner: current_user
      render_success
    else
      render_fail
    end
  end

  def open_blank
    if Law.find(params[:id]).create_activity key: 'law.open_blank', owner: current_user
      render_success
    else
      render_fail
    end
  end

  # def audio_played
  #   Law.find(params[:law_id]).create_activity key: 'law.audio_played', owner: current_user
  # end

  def forget_password
    user = User.where(:email=>params[:email]).first
    if user
      user.forgot_password!
      ClearanceMailer.change_password(user).deliver
      render_success
    else
      render_fail
    end
  end

  def zhentis
    @content = Question.zhentis
    render :json=>@content
  end

  def zhenti
    @relation = Question.zhenti(params[:year],params[:volumn]).order('num asc')
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
  end

  def books
    @relation = Book.where(true)
    paginate
    @content = @collection
    render :json=>@content
  end

  def schools
    city = params[:city]
    if city
      @relation = School.where(:city=>city)
    else
      @relation = School.where(true)
    end
    paginate
    @content = @collection
    render :json=>@content
  end

  def assign_captcha
    Captcha.assign(params[:value],current_user)
    @content = current_user.validity
    render :json=>@content
  end

  def user_validity
    @content = current_user.validity
    render :json=>@content
  end

  def authorize_token
    if params[:session] 
      @user = User.find_by_remember_token(params[:session][:token])
    end
    # @user = User.first
    render :json=>{:success=>false} unless @user
  end

  def current_user
    @user
  end

  def edit_profile
    if @user.update_attributes(params[:user])
      @content = {:success=>true}
      render :json=>@content
    else
      @content = {:success=>false,:errors=>@user.errors.full_messages}
      render :json=>@content
    end
  end

  def signup
    @user = user_from_params
    if @user.valid?
      sign_in(@user)
      @content = {:success=>true,:user=>@user}
      render :json=>@content
    else
      @content = {:success=>false,:errors=>@user.errors.full_messages}
      render :json=>@content
    end
  end

  def login
    if params[:session]
      @user = User.authenticate params[:session][:username],params[:session][:password]
    else
      @user = nil
    end
    sign_in(@user)
    if @user
      @content = {:success=>true,:user=>@user}
      render :json=>@content
    else
      @content = {:success=>false}
      render :json=>@content
    end
  end

  def logout
    
  end


  def mix
    # 整体掌握情况
    mastered_status = History.mastered_status(nil,current_user)
    # 默认返回值 ，是所有掌握未掌握的id ， api需要返回数量
    mastered_status[:unmastered] = mastered_status[:unmastered].size
    mastered_status[:mastered] = mastered_status[:mastered].size
    # 开始缓存
    current_user.auto_cache_setting
    @content = {
      :istudy_epmenus_summaries=>current_user.settings.istudy_epmenus_summaries,
      :istudy_complex_rank=>current_user.settings.istudy_complex_rank,
      :istudy_xueba=>current_user.settings.istudy_xueba,
      :istudy_evaluate=>current_user.settings.istudy_evaluate,
      :istudy_time=>current_user.time,
      :mastered_status=>mastered_status
    }
    render :json=>@content
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
    @content = laws_to_json(relation)
    render :json=>@content
  end


  #法条班法条  
  def laws
  	if params[:id] == nil
  		@relation = Law.ordered_roots
  	else
  		@relation = Law.find(params[:id]).ordered_children
  	end
    paginate
    @content = laws_to_json(@collection)
  	render :json=>@content
  end


  # 免费法条
  def freelaws
  	if params[:id] == nil
  		@relation = Freelaw.ordered_roots
  	else
  		@relation = Freelaw.find(params[:id]).ordered_children
  	end
    paginate
    @content = freelaws_to_json(@relation)
  	render :json=>@content
  end

  def law_blanks
    @content = Law.find(params[:id]).blanks
    render :json=>@content
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
    @content = eps_to_json(@collection)
  	render :json=>@content
  end

  # 根据知识点返回问题
  def ep_questions
    @relation = Exampoint.find(params[:id]).questions
    paginate
    @content = wrap_questions(@collection)
  	render :json=> @content
  end

  # 根据法条返回问题
  def law_questions
    @relation = Law.find(params[:id]).questions
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
  end

  # 返回知识点菜单结构
  def epmenus
    if params[:epmenu_id] == nil
      @content = Epmenu.roots.select(%w(id title))
    	render :json=>@content
    else
      @content = Epmenu.find(params[:epmenu_id]).children.select(%w(id title))
      render :json=>@content
    end
  end

  # 根据知识点菜单结构随机返回题
  def epmenu_questions
    questions = R.new.rand_questions_by_epm(Epmenu.find(params[:id]),params[:limit].to_i)
    questions = Question.where(:id=>questions.collect{|i|i.id})
    @content = wrap_questions(questions)
  	render :json=>@content
  end

  # 随机输入  
  def rapid_questions
    # questions = R.new.rand_questions_by_epms(Epmenu.roots.where('volumn'=>params[:volumn]),params[:limit].to_i)
    # questions = Question.where(:id=>questions.collect{|i|i.id})
    volumn = params[:volumn]
    volumn = "0#{volumn}" if volumn.size == 1
    year_first = Question.order('num asc').limit(1).first.num.to_s[0..3].to_i
    year_last = Question.order('num desc').limit(1).first.num.to_s[0..3].to_i
    year = (year_first..year_last).to_a.sample
    questions = Question.where("num like '#{year}#{volumn}%'").random(15)
    @content = wrap_questions(questions)
    render :json=>@content
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
    History.log(current_user.id,params[:question_id],params[:result],params[:originalMyAnswer])
    render_success
  end

  def answer_questions    
    if params[:data].class == Array
      params[:data] = Hash[(0...params[:data].size).zip params[:data]]

      params[:data].each_pair do |_,item|
        History.log(current_user.id,item[:id],item[:result],item[:originalMyAnswer])
      end
    end

    render_success
  end

  def mistake_epmenus
    @content = History.mistake_epmenus(current_user)
    render :json=>@content
  end


  def mistake_eps
    histories = History.wrong.where(:user_id=>current_user.id)
    @relation = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')

    paginate

    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').group('created_at').count().keys.size
      attrs
    end
    @content = eps_to_json(@collection)
    render :json=>@content
  end

  def mistake_eps_by_epmenu
    histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    @relation = Exampoint.where(:id=>histories.collect{|i|i.exampoint_id}).select('id,title')
    paginate
    @collection = @collection.map do |i|
      attrs = i.attributes
      attrs[:questions_count] = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>i.id).select('distinct `question_id`').group('created_at').count().keys.size
      attrs
    end
    @content = eps_to_json(@collection)
    render :json=>@content
  end

  def mistake_questions_by_ep
    histories = History.wrong.where(:user_id=>current_user.id,:exampoint_id=>params[:exampoint_id])
    @relation = Question.where(:id=>histories.collect{|i|i.question_id})
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
  end

  def mistake_questions_by_epmenu
    questions_id = History.mastered_status(Epmenu.find(params[:epmenu_id]),current_user)[:unmastered]
    @relation = Question.where(:id=>questions_id)
    # histories = History.wrong.where(:user_id=>current_user.id,:epmenu_id=>params[:epmenu_id])
    # @relation = Question.where(:id=>histories.collect{|i|i.question_id})
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
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
    @content = @collection
    render :json=>@content
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
    @content = eps_to_json(@collection)
    render :json=>@content
  end

  # 通过收藏考点查找真题
  def collected_questions_by_ep
    @relation = Collect.children(current_user,Exampoint.find(params[:id]))
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
  end

  # 基于收藏真题查找收藏知识点
  def collected_eps
    @relation = Collect.roots(current_user,'QuestionEp').select(%w(id title))
    paginate
    @content = eps_to_json(@collection)
    render :json=>@content
  end  

  def collected_questions_by_epmenu
    eps =  Collect.children(current_user,Epmenu.find(params[:id]))
    questions = eps.collect do |ep|
      Collect.children(current_user,ep)
    end.flatten.uniq
    @relation = Question.where(:id=>questions.collect{|i|i.id})
    paginate
    @content = wrap_questions(@collection)
    render :json=>@content
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

    @content = laws_to_json(Search.search(who,action,searchable,keyword))
    render :json=>@content
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

    @content = freelaws_to_json(Search.search(who,action,searchable,keyword))
    render :json=>@content
  end

  # 发送开始心跳
  def heartbeat_start
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    hb = Heartbeat.log_start(current_user,beatable)
    hb.set_duration
    @content = {:interval=>Heartbeat::Interval}
    render :json=>@content
  end

  # 发送心跳
  def heartbeat_beat
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    hb = Heartbeat.log_beat(current_user,beatable)
    hb.set_duration
    current_user.cache_complex
    @content = {:interval=>Heartbeat::Interval}
    render :json=>@content
  end

  # 发送停止心跳
  def heartbeat_stop
    if params[:id]
      beatable = Law.find(params[:id])
    else
      beatable = current_user
    end
    hb = Heartbeat.log_stop(current_user,beatable)
    hb.set_duration
    @content = {:interval=>Heartbeat::Interval}
    render :json=>@content
  end
# 每个部门法的累计学习时间 / 用户累计使用软件的时间和天数
# id 部门法id , 必填 . 如果没有id, 则返回所有部门法的时间 , 有id , 返回指定部门法
# from,to:可选 , 格式为 2013-09-27 15:19:00
# 返回值 : 包含用户使用软件的天数和时间 
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

    @content = Heartbeat.summary(current_user,beatable,from,to)
    render :json=>@content
  end

  def istudy_epmenu_summary
    @content = Istudy.epmenu_summary(current_user,params[:type])
    render :json=>@content
  end

  def istudy_sub_epmenus_summaries
    @content = Istudy.sub_epmenus_summaries(current_user,params[:id])
    render :json=>@content
  end

  def istudy_epmenus_summaries
    @content = Istudy.epmenus_summaries(current_user)
    render :json=>@content
  end

  def istudy_xueba
    @content = {:value=>Istudy.xueba(current_user)}
    render :json=>@content
  end

  def istudy_complex
    @content = {:value=>Istudy.complex(current_user)}
    render :json=>@content
  end

  def istudy_complex_rank
    @content = Istudy.complex_rank(current_user)
    render :json=>@content
  end

  def istudy_evaluate
    @content = {:value=>Istudy.evaluate(current_user)}
    render :json=>@content
  end

  def history
    @content = {
      :total=>History.by_user(current_user).count(),
      :right=>History.by_user(current_user).right.count(),
      :wrong=>History.by_user(current_user).wrong.count(),
    }
    render :json=>@content
  end

  def history_by_epmenu
    base = History.where(
      :user_id=>current_user.id,
      :epmenu_id=>params[:id]
    )
    @content = {
      :total=>base.count(),
      :right=>base.where(:state=>:right).count(),
      :wrong=>base.where(:state=>:wrong).count(),
    }
    render :json=>@content
  end

  def history_by_epmenu_eps
    epmenu = Epmenu.find(params[:id])
    eps = epmenu.exampoints.select(%w(id title))

    base = History.where(
      :user_id=>current_user.id,
      :epmenu_id=>params[:id],
    )

    @content = eps.collect do |ep|
      attributes = ep.attributes
      attributes[:total]= base.where(:exampoint_id=>ep.id).count()
      attributes[:right]= base.where(:exampoint_id=>ep.id,:state=>:right).count()
      attributes[:wrong]= base.where(:exampoint_id=>ep.id,:state=>:wrong).count()
      attributes
    end
    render :json=>@content
  end

  def history_total_avg_by_epmenu
    base = History.where(
      :epmenu_id=>params[:id]
    )

    total = base.count()
    right = base.where(:state=>:right).count()

    @content = {:value=>right*1.0/total*15}
    render :json=>@content
  end

  def history_total_avg_by_epmenu_eps
    epmenu = Epmenu.find(params[:id])

    eps = epmenu.exampoints.select(%w(id title))

    base = History.where(
      :epmenu_id=>params[:id],
    )

    @content = eps.collect do |ep|
      attributes = ep.attributes
      total = base.where(:exampoint_id=>ep.id).count()
      right = base.where(:exampoint_id=>ep.id,:state=>:right).count()
      attributes[:value] = right*1.0/total*15
      attributes[:value] = 0 if attributes[:value].nan?
      attributes
    end
    render :json=>@content
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
      laws = laws.select(%w(id state title category blanks ancestry ancestry_depth sound_file_name sound_content_type sound_file_size sound_updated_at))
    end

    laws.each do |law|
      law.current_user = current_user
    end

    if laws.first && laws.first.ancestry_depth >= 3
      laws.to_json(
        :include=>{:exampoints=>{}},
        :methods=>[:is_collected,:sound_url,:children_state,:questions_count]
      )
    else
      laws.to_json(
        :methods=>[:is_collected,:sound_url,:children_state]
      )
    end
  end

  def freelaws_to_json(freelaws)
    if freelaws.is_a? ActiveRecord::Relation
      freelaws = freelaws.select(%w(id state ancestry title category ancestry_depth))
    end

    freelaws.each do |freelaw|
      freelaw.current_user = current_user
    end

    freelaws.to_json(
      :methods=>[:is_collected,:children_state]
    )
  end

  def eps_to_json(eps)
    eps.collect do |ep|
      attributes = ep.attributes
      attributes[:complex] = 0.1
      attributes
    end
  end

  # private 
  # # 在返回集合的api上设置分页的页数和分页大小
  # # 结果：设置好 @page 和 @per_page
  # def paginate_params
  #   @page = params[:page] || 1 
  #   @per_page = params[:per_page] || 1000
  #   @random = params[:random].to_i || 0
  # end

  # # 根据分页的数量
  # # require @page
  # # require @per_page
  # # set @collection
  # def paginate
  #   if @random == 0
  #     @collection = @relation.paginate(:page=>@page,:per_page=>@per_page)
  #   else
  #     @collection = @relation.random(@per_page)
  #   end
  # end

  def user_from_params
    user_params = params[:user] || Hash.new
    email = user_params.delete(:email)
    password = user_params.delete(:password)

    Clearance.configuration.user_model.new(user_params).tap do |user|
      user.email = email
      user.password = password
    end
  end

  # def assign_trial_captcha

  # end

  def log(method,content)
    Dlog.create :content=>content,:params=>params,:method=>method,:user_id=>current_user.try(:id)
  end

  def save_dlog
    begin
      # Dlog.create :content=>@content,:params=>params,:method=>params[:action],:user_id=>current_user.try(:id)
    rescue
    end
  end


end

