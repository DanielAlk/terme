module PanelHelper
	def panel_nav_class(path)
		if request.path == path
			'active'
		elsif controller_name.to_sym == path
			'active'
		end
	end
end
