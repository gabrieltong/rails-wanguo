class Heartbeat < ActiveRecord::Base
	Interval = 5.minutes
  attr_accessible :user_id,:state
  belongs_to :user
  validates :user,:presence=>true

  def self.start(user)
  	hb = Heartbeat.new :state=>:start
  	hb.user = user
  	hb.save
  end

  def self.beat(user)
  	hb = Heartbeat.new :state=>:beat
  	hb.user = user
  	hb.save
  end

  def self.stop(user)
  	hb = Heartbeat.new :state=>:stop
  	hb.user = user
  	hb.save
  end
end
