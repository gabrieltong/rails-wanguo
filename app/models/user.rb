class User < ActiveRecord::Base
	has_many :collects

	has_many :histories

	has_many :epmenus,:through=>:histories,:uniq=>true

  include Clearance::User

  def email_optional?
    true
  end

  def self.authenticate(username, password)
    return nil  unless user = find_by_username(username)
    return user if     user.authenticated?(password)
  end
end
