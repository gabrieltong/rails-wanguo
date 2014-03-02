class History < ActiveRecord::Base
  Limit = 2

  attr_accessible :epmenu_id, :exampoint_id, :question_id, :state, :user_id

  belongs_to :user
  belongs_to :question
  belongs_to :exampoint
  belongs_to :epmenu

  scope :by_epmenu, lambda {|epmenu|where(:epmenu_id=>epmenu.id)}
  scope :by_user, lambda {|user|where(:user_id=>user.id)}

  state_machine :state,:initial=>:wrong  do
  	state :wrong do
  	end
  	
  	state :right do
  	end
  end

  state_machine.states.map do |state|
    scope state.name, :conditions => { :state => state.name.to_s }
  end

  # 记录用户答题情况 ， 
  def self.log(user_id,question_id,result,answer)
  	answer.upcase!
  	user = User.find(user_id)
  	question = Question.find(question_id)		
  	exampoints = []
  	('a'..'h').to_a & (question.answer.split('') | answer.split('')).each do |i|
			exampoints = exampoints | question.send("#{i.downcase}_eps")
  	end

  	if exampoints.blank?
	  	history = History.new()
        history.user = user
        history.question = question
        history.answer = answer
        history.state = (result.to_i == 1 ? :right : :wrong)
        history.save
	  else
      epmenu = exampoints.first.epmenus.roots.first
      exampoints.each do |ep|
        history = History.new()
        history.user = user
        history.question = question
        history.exampoint = ep
        history.answer = answer
        history.epmenu = epmenu
        history.state = (result.to_i == 1 ? :right : :wrong)
        history.save
      end
    end
	end

  # 用户答题正确率
  def self.correct_rate(user)
    right_count = History.by_user(user).right.group('created_at').count().keys.size
    wrong_count = History.by_user(user).wrong.group('created_at').count().keys.size
    if right_count+wrong_count == 0
      return 0
    else
      return right_count*1.0/(right_count+wrong_count)
    end
  end


  # 用户部门法掌握情况 。 
  def self.mastered_status(epmenu,user)
    # 如果有部门法 ， 取得关于部门法的消息 ，否则 ，取得所有
    if epmenu
      histories = History.by_epmenu(epmenu).by_user(user).group('question_id').select(%w(question_id exampoint_id))
      total = epmenu.questions.count()
    else
      histories = History.by_user(user).group('question_id').select(%w(question_id exampoint_id))
      total = Question.count()
    end

    mastered = []
    unmastered = []
    unmastered_eps = []
    
    histories.each do |history|
      status =  History.question_status history.question,user
      if status == :right
        mastered.push history.question.id
      elsif status == :wrong
        unmastered.push history.question.id
        unmastered_eps.push history.exampoint_id
      end
    end
    {
      :mastered=>mastered.compact.uniq.sort,
      :unmastered=>unmastered.compact.uniq.sort,
      :unmastered_eps=>unmastered_eps.compact.uniq.sort,
      :total=>total
    }
  end

  # 用户针对某道题的答题情况
  # return [:wrong,:right,nil]
  def self.question_status question,user
    return nil if question.nil?
    relation = History.where(:question_id=>question.id,:user_id=>user.id).group(:created_at).order('created_at desc').limit(History::Limit)
    return nil if relation.count().keys.size == 0
    relation.each do |history|
      return :wrong if history.wrong?
    end
    :right
  end  

  # 用户有错题的部门法 。 
  def self.mistake_epmenus user
    list = []
    Epmenu.roots.each do |epmenu|
      ss = History.mastered_status(epmenu,user)
      if ss[:unmastered].size > 0 
        item = epmenu.attributes
        item[:questions_count] = ss[:unmastered].size
        item[:eps_count] = ss[:unmastered_eps].size
        list.push item
      end
    end
    list
  end
  # def self.epmenu_status epmenu,user
  #   relation = History.where(:epmenu_id=>epmenu.id,:user_id=>user.id)
  #   return 
  # end
end
