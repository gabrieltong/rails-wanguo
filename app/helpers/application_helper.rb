# encoding: UTF-8
module ApplicationHelper
	def minutes_to_days(minutes)
    minutes/(24*60)
  end

  def seconds_to_time(seconds)
  	days = seconds/(60*60*24)
  	last = seconds % (60*60*24)

  	hours = last/(60*60)
  	last = last% (60*60)

  	minutes = last/60

  	seconds = last%60

  	"#{days}天#{hours}小时#{minutes}分钟"
  end
end
