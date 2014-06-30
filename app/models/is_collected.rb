module IsCollected

  def self.included(klass)
    attr_accessor :current_user
  end

  def is_collected
    if current_user.is_a? User
    	Collect.is_collected(current_user,self)
    else
    	false
    end
  end

  class NoCurrentUser < StandardError
  end

end