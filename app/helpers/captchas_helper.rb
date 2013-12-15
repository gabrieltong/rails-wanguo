module CaptchasHelper
  def minutes_to_days(seconds)
    seconds/(24*60)
  end

	def tab_class(action)
		if action.to_s == params[:action]
			'active'
		else
			''
		end
	end
end
