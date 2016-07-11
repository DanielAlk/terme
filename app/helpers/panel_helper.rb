module PanelHelper
	def profile_nav_class(path)
		if request.path == path
			'active'
		end
	end
end
