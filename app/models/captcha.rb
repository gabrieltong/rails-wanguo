class Captcha < ActiveRecord::Base
  attr_accessible :title, :used_at, :user_id
  belongs_to :user
  def self.assign(value,user)
    captchas = Captcha.where(:title=>value,:user_id=>nil)
    if user && user.captchas.count() == 0 && captchas.count() > 0
      captchas.each do |c|
        c.used_at = DateTime.now
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
end
