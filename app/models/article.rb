class Article < ActiveRecord::Base
	extend FriendlyId
	include Tinymce
	friendly_id :slug_candidates, use: :slugged
	has_attached_file :image, styles: Proc.new { |attachment| attachment.instance.shape_image_style }, default_url: "product-imgs/p-:style.jpg"
	validates_attachment :image, presence: true, content_type: { content_type: /\Aimage\/.*\Z/ }, if: :shape_has_image?

	acts_as_list scope: [:shape], add_new_at: :top

	tinymce columns: [ :text ]
	
	enum shape: [ :showcase, :news, :about, :services, :partners ]

	def shape_sp
		{ showcase: 'showcase', news: 'noticia', about: 'la empresa', services: 'servicio', partners: 'partners' }[self.shape.to_sym]
	end

	def self.shape_sp(shape)
		{ showcase: 'showcase', news: 'noticia', about: 'la empresa', services: 'servicio', partners: 'partners' }[shape]
	end

	def self.shape_has?(column, shape)
		Article.new(shape: shape).send('shape_has_' + column.to_s + '?')
	end

	def self.shape_is_sortable?(shape)
		[ :showcase, :about, :services, :news ].include? shape.to_sym
	end

	def self.shape_highlited(shape)
		{ about: 1, news: 3 }[shape.to_sym]
	end

	def shape_image_style
		{
			showcase: {
				big: '1920x895#',
				medium: '760x760#',
				thumb: '150x110#'
			},
			news: {
				big: '1467x474#',
				medium: '760x760#',
				small: '755x323#',
				thumb: '150x110#'
			}
		}[self.shape.to_sym]
	end

	def shape_has_title?
		[ :showcase, :news, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_subtitle?
		[ :showcase, :news ].include? self.shape.to_sym
	end

	def shape_has_description?
		[ :showcase ].include? self.shape.to_sym
	end

	def shape_has_text?
		[ :news, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_link?
		[ :showcase, :about, :services, :partners ].include? self.shape.to_sym
	end

	def shape_has_image?
		[ :showcase, :news ].include? self.shape.to_sym
	end

	def link=(url)
		if Rails.env.development?
			write_attribute :link, url.gsub(/http:\/\/(?:panel\.local\.)?localhost:3000/, '')
		else
			write_attribute :link, url.gsub(/https?:\/\/(?:panel\.|www\.)?terme.com.ar/, '')
		end
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