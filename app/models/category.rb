class Category < ActiveRecord::Base
	extend FriendlyId
  friendly_id :title, use: :slugged
	has_ancestry

	def path_to_s
		self.path_ids.join '/'
	end

	def is_not_new_and_has_children?
		!self.new_record? && self.has_children?
	end

end
