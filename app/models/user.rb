class User < ActiveRecord::Base
  include RailsSettings::Extend
  has_many :tracked_activities,:as=>:trackable,:class_name=>'Activity'
  has_many :owned_activities,:as=>:recipient,:class_name=>'Activity'
  rolify
  attr_accessible :username, :phone, :qq,:signature,:password_confirm,:nickname

	has_many :collects

  has_many :heartbeats

  has_many :captchas

	has_many :histories

	has_many :epmenus,:through=>:histories,:uniq=>true

  validates :username,:email,:phone,:presence=>true
  validates :username, :length => { :minimum => 3 }

  # validates :qq,:numericality => { :only_integer => true }
  validates :phone,:numericality => { :only_integer => true }
  
  validates :username,:uniqueness=>true
  validates :email,:uniqueness=>true
  # validates :qq,:uniqueness=>true
  validates :phone,:uniqueness=>true
  
  after_save :assign_trial_captcha
  after_create :cache_setting
  # after_save :cache_setting
  # after_save :assign_trial_captcha
  # validates :password, :confirmation => true,:unless => Proc.new { |a| a.password.blank? }
  include Clearance::User

  def email_optional?
    true
  end

  def self.authenticate(username, password)
    return nil  unless user = find_by_username(username)
    return user if     user.authenticated?(password)
  end

  def period_of_validity
    last_valid_captcha = self.captchas.order('expired_at desc').first()
    last_valid_captcha ? (last_valid_captcha.expired_at - DateTime.now).to_i : 0
  end

  def validity
    {
      :active=>self.captchas.count()>0,
      :seconds=>period_of_validity
    }
  end

  def assign_trial_captcha
    if self.captchas.reload && self.captchas.blank?
      captcha = Captcha.generate(1,1)[0]
      Captcha.assign captcha.title,self
    end
  end

  def cache_setting
    Setting.where(:thing_type=>self.class,:thing_id=>self.id).destroy_all
    self.settings.istudy_epmenus_summaries = Istudy.epmenus_summaries(self)
    self.settings.istudy_xueba = Istudy.xueba(self)
    self.settings.istudy_complex_rank = Istudy.complex_rank(self)
    self.settings.istudy_evaluate = Istudy.evaluate(self)
    # self.settings.istudy_time = Heartbeat.duration(Heartbeat.ranges(self,self))
  end

  def self.cache_setting
    Istudy.cache_complex
    User.all.each do |user|
      user.cache_setting
    end
  end

  def auto_cache_setting
    first_setting = Setting.where(:thing_type=>self.class,:thing_id=>self.id).first
    if first_setting.nil? || (first_setting.updated_at + 1.day < DateTime.now)
      self.cache_setting
    end    
  end

  def play_audio_count
    owned_activities.get_stat(:play_audio_count)
  end

  def open_blank_count
    owned_activities.get_stat(:open_blank_count)
  end

  def time
    heartbeats.statistics[:sum_time]
  end
end
