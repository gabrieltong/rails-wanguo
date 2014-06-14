class Phonesign < ActiveRecord::Base
  attr_accessible :phone
  validates :phone,:format=> {:with=>/^1[3|4|5|7|8][0-9]\d{8}$/}
  after_save do |record|
  	unless record.sign
	  	record.sign = generate
	  	record.save
	  end
  end

  # private
  def generate(size = 6)
  	s = ''
  	size.times do
  		s = "#{s}#{rand(10)}"
  	end
  	s
  end
end

