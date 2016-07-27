module ApplicationHelper
	def root_path
		if admin_signed_in?
			home_path
		else
			super
		end
	end
end
