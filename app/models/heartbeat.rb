class Heartbeat < ActiveRecord::Base
	Interval = 5.minutes
  attr_accessible :user_id,:state
  belongs_to :user
  belongs_to :beatable,:polymorphic=>true
  validates :user,:presence=>true

  def self.start(user,beatable)
  	hb = Heartbeat.new :state=>:start
    hb.beatable = beatable
  	hb.user = user
  	hb.save
  end

  def self.beat(user,beatable)
  	hb = Heartbeat.new :state=>:beat
    hb.beatable = beatable
  	hb.user = user
  	hb.save
  end

  def self.stop(user,beatable)
  	hb = Heartbeat.new :state=>:stop
    hb.beatable = beatable
  	hb.user = user
  	hb.save
  end

  def self.status(user,beatable,from=DateTime.new(2000,1,1),to=DateTime.new(3000,1,1))
    base = Heartbeat.where(
      :beatable_type=>beatable.class,
      :beatable_id=>beatable.id,
      :user_id=>user.id
    )

    pairs = base.where(:state=>:start,:created_at=>from..to).map {|start|{:start=>start,:end=>nil}}

    pairs.each_with_index do |pair,index|
      _from = pair[:start].created_at
      if pairs[index+1]
        _to = pairs[index+1][:start].created_at
      else
        _to = to
      end
      pair[:end] = base.where(:state=>[:stop,:beat],:created_at=>_from.._to).order('`created_at` desc').limit(1).first
    end
    
    _from = from
    if pairs.first
      _to = pairs.first[:start].created_at
    else
      _to = to
    end
    _start = base.where(:state=>[:beat],:created_at=>_from.._to).order('`created_at` asc').limit(1).first
    _end = base.where(:state=>[:beat],:created_at=>_from.._to).order('`created_at` desc').limit(1).first

    if _start && _end
      pairs.insert(0,{:start=>_start,:end=>_end})
    end

    pairs.collect {|pair|{:start=>pair[:start].created_at,:end=>pair[:end].created_at}}
  end

  module HasManyRelation
    def self.included(base)
      base.class_eval do
        has_many :beatable
      end
    end
  end 
end

Law.send(:include,Heartbeat::HasManyRelation)
# Epmenu.send(:include,Heartbeat::HasManyRelation)