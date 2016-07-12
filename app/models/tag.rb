class Tag < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged
	has_many :taggings, dependent: :destroy
	validates_uniqueness_of :name

	def name=(name)
		write_attribute(:name, name.titlecase)
	end

	private
		def should_generate_new_friendly_id?
			name_changed?
		end

		def slug_candidates
			[
				:name,
				[ :name, :id ]
			]
		end
	
end
