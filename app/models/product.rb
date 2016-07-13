class Product < ActiveRecord::Base
	extend FriendlyId
	friendly_id :slug_candidates, use: :slugged
	belongs_to :category
  has_many :images, -> { order(position: :asc) }, as: :imageable, dependent: :destroy
  has_many :reviews, as: :reviewable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  validates_length_of :title, minimum: 5, message: "debe contener al menos 5 caracteres"
  validates_presence_of :category_id
  validates_presence_of :price
  validates_presence_of :currency

  enum status: [ :draft, :active, :paused, :trash ]
  enum currency: [ '$', 'u$s' ]

  def price=(price)
    write_attribute(:price, price.gsub('.', '').gsub(',', '.'))
  end
  def characteristics=(characteristics)
    sanitizer = Rails::Html::WhiteListSanitizer.new
    sanitized = sanitizer.sanitize(characteristics, tags: %w(strong em br a), attributes: %w(href))
    write_attribute(:characteristics, sanitized)
  end
  def data_sheet=(data_sheet)
    sanitizer = Rails::Html::WhiteListSanitizer.new
    sanitized = sanitizer.sanitize(data_sheet, tags: %w(strong em br a), attributes: %w(href))
    write_attribute(:data_sheet, sanitized)
  end
  def information=(information)
    sanitizer = Rails::Html::WhiteListSanitizer.new
    sanitized = sanitizer.sanitize(information, tags: %w(strong em br a), attributes: %w(href))
    write_attribute(:information, sanitized)
  end

  def dimensions
    width_cm.to_s + 'x' + height_cm.to_s + 'x' + depth_cm.to_s + ' cm.'
  end

  def status_translated
    {draft: 'Borrador', active: 'Activa', paused: 'Pausada'}[self.status.to_sym]
  end

  def image(size = :thumb)
    self.images.first.item.url(size) rescue "product-imgs/p-#{size}.jpg"
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