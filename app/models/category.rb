class Category < ActiveRecord::Base
	extend FriendlyId
  friendly_id :title, use: :slugged
	has_ancestry

	def path_to_s
		self.path_ids.join '/'
	end
end
