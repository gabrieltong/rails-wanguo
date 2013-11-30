class User < ActiveRecord::Base
  rolify
  attr_accessible :username, :phone, :qq,:signature,:password_confirm

	has_many :collects

  has_many :captchas

	has_many :histories

	has_many :epmenus,:through=>:histories,:uniq=>true

  validates :username,:email,:phone,:presence=>true
  validates :username, :length => { :minimum => 3 }

  after_save :assign_trial_captcha
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
end
