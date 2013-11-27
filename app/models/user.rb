class User < ActiveRecord::Base
  attr_accessible :username, :phone, :qq,:signature,:password_confirm

	has_many :collects

  has_many :captchas

	has_many :histories

	has_many :epmenus,:through=>:histories,:uniq=>true

  validates :username,:email,:phone,:presence=>true
  validates :username, :length => { :minimum => 3 }

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
end
