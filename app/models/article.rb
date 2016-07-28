class Article < ActiveRecord::Base
	extend FriendlyId
	include Tinymce
	friendly_id :slug_candidates, use: :slugged
	has_attached_file :image, styles: { big: "2000x1455#", medium: "1100x800#", small: "500x460#", thumb: "150x110#" }, default_url: "product-imgs/p-:style.jpg"
	validates_attachment :image, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, if: :shape_has_image?

	tinymce columns: [ :text ]
	#acts_as_list scope: :shape
	
	enum shape: [ :showcase, :news, :about, :services, :partners ]

	def shape_sp
		{ showcase: 'showcase', news: 'noticia', about: 'la empresa', services: 'servicio', partners: 'partners' }[self.shape.to_sym]
	end

	def shape_has_title?
		[ :showcase, :news, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_subtitle?
		[ :showcase ].include? self.shape.to_sym
	end

	def shape_has_description?
		[ :showcase ].include? self.shape.to_sym
	end

	def shape_has_text?
		[ :news, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_link?
		[].include? self.shape.to_sym
	end

	def shape_has_link_to_page?
		[ :showcase, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_image?
		[ :showcase, :news ].include? self.shape.to_sym
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