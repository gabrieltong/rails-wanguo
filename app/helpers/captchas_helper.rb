module CaptchasHelper

	def tab_class(action)
		if action.to_s == params[:action]
			'active'
		else
			''
		end
	end
end
