class Category < ActiveRecord::Base
	extend FriendlyId
  friendly_id :slug_candidates, use: :slugged
	has_ancestry

	validates_presence_of :title

	def path_to_s
		self.path_ids.join '/'
	end

	def is_not_new_and_has_children?
		!self.new_record? && self.has_children?
	end

	private
		def should_generate_new_friendly_id?
		  title_changed?
		end

		def slug_candidates
		  [
		    :title,
		    [ :title, :id ]
		  ]
		end

end
