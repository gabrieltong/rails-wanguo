class Inolink
	include HTTParty

	def batch_send(mobile,content)
		url = "http://inolink.com/ws/BatchSend.aspx?CorpID=TCLKJ00626&Pwd=123321&Mobile=#{mobile}&Content=#{content}"
		response = HTTParty.get(url)
		response.body
	end

end