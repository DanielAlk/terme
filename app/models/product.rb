class Product < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged
	belongs_to :category
  has_many :images, as: :imageable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  validates_length_of :title, minimum: 5, message: "debe contener al menos 5 caracteres"
  validates_presence_of :category_id
  validates_presence_of :price
  validates_presence_of :currency
  before_save :clean_tinymce

  enum status: [ :draft, :active, :paused, :trash ]
  enum currency: [ '$', 'u$s' ]

  def price=(price)
    write_attribute(:price, price.gsub('.', '').gsub(',', '.'))
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

  	def clean_tinymce
  	  sanitizer = Rails::Html::WhiteListSanitizer.new
  	  self.characteristics = sanitizer.sanitize(self.characteristics, tags: %w(strong em br a), attributes: %w(href))
			self.data_sheet = sanitizer.sanitize(self.data_sheet, tags: %w(strong em br a), attributes: %w(href))
			self.information = sanitizer.sanitize(self.information, tags: %w(strong em br a), attributes: %w(href))
  	end
end