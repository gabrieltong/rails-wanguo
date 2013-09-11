class R
	def rand_epmenus(relation,limit)
		relation.random(limit).select('id')
	end

	def rand_epmenus_by_volumn(volumn,limit)
		rand_epmenus Epmenu.roots.where('volumn'=>volumn),limit
	end

	def rand_eps_by_epmenus(epmenus,limit)

	end

end