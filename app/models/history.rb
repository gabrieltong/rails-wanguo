class History < ActiveRecord::Base

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

  def self.log(user_id,question_id,result,answer)
  	answer.upcase!
  	user = User.find(user_id)
  	question = Question.find(question_id)		
  	exampoints = []
  	(question.answer.split('') | answer.split('')).each do |i|
			exampoints = exampoints | question.send("#{i.downcase}_eps") 		
  	end

  	unless exampoints.blank?
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

  def self.correct_rate(user)
    right_count = History.by_user(user).right.group('created_at').count().keys.size
    wrong_count = History.by_user(user).wrong.group('created_at').count().keys.size
    if right_count+wrong_count == 0
      return 0
    else
      return right_count*1.0/(right_count+wrong_count)
    end
  end

  def self.mastered_status(epmenu,user)
    
    unless epmenu
      return {
        :mastered=>[],
        :unmastered=>[],
        :total=>1,
      }
    end

    pass_ratio = 0.8
    mastered = []
    unmastered = []

    histories = History.by_epmenu(epmenu).by_user(user).group('question_id').select("question_id")
    # histories.each do |history|
    #   right_count = History.by_epmenu(epmenu).by_user(user).where('question_id'=>history.question_id).right.count()
    #   wrong_count = History.by_epmenu(epmenu).by_user(user).where('question_id'=>history.question_id).wrong.count()
    #   if right_count*1.0/(right_count+wrong_count) > pass_ratio
    #     mastered.push history.question_id
    #   else
    #     unmastered.push history.question_id
    #   end
    # end
    test_limit = 3
    histories.each do |history|
      master_status = true
      History.by_epmenu(epmenu).by_user(user).where('question_id'=>history.question_id).order('id desc').limit(test_limit).each do |h|
        if h.wrong?
          master_status = false
        end      
      end
      if master_status == true
        mastered.push history.question_id
      else
        unmastered.push history.question_id
      end
    end
    {
      :mastered=>mastered,
      :unmastered=>unmastered,
      :total=>epmenu.questions.count()
    }
  end
end
