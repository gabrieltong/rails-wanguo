module IsCollected

  def self.included(klass)
    attr_accessor :current_user
  end

  def is_collected
    raise NoCurrentUser unless (current_user.is_a? User)
    Collect.is_collected(current_user,self)
  end

  class NoCurrentUser < StandardError
  end

end