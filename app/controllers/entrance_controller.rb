class EntranceController < ApplicationController
  def callback
  	# ppp params
  end

  def welcome
  end

  def download

  end

  def download_link
	user_agent = UserAgent.parse(request.user_agent)
	if user_agent.platform.downcase == 'ipad' || user_agent.platform.downcase == 'ipone'
		redirect_to 'http://mp.weixin.qq.com/mp/redirect?url=https://itunes.apple.com/cn/app/wan-guo-si-kao/id852759260?mt=8'
	else
		redirect_to 'http://zhushou.360.cn/detail/index/soft_id/1579992?recrefer=SE_D_'
	end
  end
end
