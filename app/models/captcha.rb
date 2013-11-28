class Captcha < ActiveRecord::Base
  Duration = 30.days
  attr_accessible :title, :valid_at, :user_id,:assigned_at,:expired_at
  belongs_to :user

  scope :valid,:conditions=>["expired_at>?",DateTime.now]
  scope :expired,:conditions=>["expired_at is not null and expired_at<=?",DateTime.now]
  scope :unused,:conditions=>['user_id is null']

  def self.assign(value,user)
    captchas = Captcha.where(:title=>value,:user_id=>nil)
    if user && captchas.count() > 0
      captchas.each do |c|
        c.assigned_at = DateTime.now
        c.valid_at = user.captchas.valid.last.try(:expired_at) || DateTime.now
        c.expired_at = c.valid_at + Duration
        c.user = user
        c.save
      end
    else
      return false
    end
  end

  def self.generate(size=10)
    size.times do 
      Captcha.create :title=>Captcha.random
    end
  end

  def self.random
    value = nil
    until Captcha.exists?(:title=>value) == false && value != nil
      value = (0...16).map { (65 + rand(26)).chr }.join
    end 
    value
  end

  # state_machine :state,:initial=>:unused  do
  #   state :unused do
  #   end

  #   state :valid do
  #   end
    
  #   state :expired do
  #   end

  #   event :use do
  #     transition :unused=>:valid
  #   end

  #   event :expire do
  #     transition :valid=>:expired
  #   end
  # end

  # state_machine.states.map do |state|
  #   scope state.name, :conditions => { :state => state.name.to_s }
  # end

  # def fix_state
  #   if self.user_id == nil || self.used_at == nil || self.expired_at == nil 
  #     self.user_id = nil
  #     self.used_at = nil
  #     self.expired_at = nil
  #     self.state = :unused
  #     self.save
  #   elsif self.expired_at < DateTime.now
  #     self.state = :valid
  #     self.save
  #   else
  #     self.state = :expired
  #     self.save
  #   end
  # end
end
