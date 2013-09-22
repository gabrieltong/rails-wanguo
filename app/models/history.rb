class History < ActiveRecord::Base

  attr_accessible :epmenu_id, :exampoint_id, :question_id, :state, :user_id

  belongs_to :user
  belongs_to :question
  belongs_to :exampoint
  belongs_to :epmenu

  state_machine :state,:initial=>:wrong  do
  	state :wrong do
  	end
  	
  	state :right do
  	end
  end

  state_machine.states.map do |state|
    scope state.name, :conditions => { :state => state.name.to_s }
  end

  def self.log(user_id,question_id,answer)
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
	  		history.state = (question.answer == answer ? :right : :wrong)
	  		history.save
	  	end
	  end
	end
end