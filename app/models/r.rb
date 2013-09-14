class R
	
	def rand_questions_by_epms(epms,limit=15)
		questions = []
		range = range(limit,epms.size)
		# p range
		epms.each_with_index do |epm,i|
			questions += rand_questions_by_epm(epm,range[i])
		end
		questions
	end

	def rand_questions_by_epm(epm,limit=15)
		return [] if limit < 1
		questions = []
		times = epm.exampoints.count 
		1.upto times do 
			ep = Exampoint.uncached {epm.exampoints.random()}
			question = ep.questions.random()
			questions.push question if question != nil && !questions.include?(question)
			break if questions.size >=limit
		end
		questions
	end

	def range(limit,piece)
		arr = [limit / (piece)]*piece
		unless limit % piece == 0
			(limit % piece).times do |i|
				arr[i] = arr[i] +1
			end
		end
		arr
	end
end