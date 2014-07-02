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
  ppp user_agent
  ppp user_agent.platform
	if user_agent.platform.downcase == 'ipad' || user_agent.platform.downcase == 'ipone'
		redirect_to 'http://mp.weixin.qq.com/mp/redirect?url=https://itunes.apple.com/cn/app/wan-guo-si-kao/id852759260?mt=8'
	else
		redirect_to 'http://m.shouji.360tpcdn.com/140508/8d7ed5585c00af1456f29c7bb4dc8163/sevencolors.android.wanguo_7.apk '
	end
  end
end
