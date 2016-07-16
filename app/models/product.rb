class Product < ActiveRecord::Base
  extend FriendlyId
  include Filterable
  include Tinymce
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

  tinymce columns: [ :characteristics, :data_sheet, :information ]

  filterable scopes: [ :status, :brand, :category, :special ]
  filterable search: [ :title, :key_code, :characteristics, :data_sheet, :information, :description ]
  filterable range: [ :price ]
  filterable order: [ :status, :title, :brand, :category, :price, :key_code, :created_at, :updated_at ]
  filterable joins: [ :reviews ]
  filterable labels: {
    order: {
      status: 'status', title: 'título', brand: 'marca', category: 'categoría', price: 'precio', key_code: 'código', created_at: 'creación', updated_at: 'modificación'
    },
    scopes: {
      status: {draft: 'borrador', active: 'activa', paused: 'pausada'},
      special: {is_regular: 'sin marca', is_new: 'nuevo', is_offer: 'oferta'}
    }
  }

  enum status: [ :draft, :active, :paused ]
  enum special: [ :is_regular, :is_new, :is_offer ]
  enum currency: [ '$' ]

  def price=(price)
    write_attribute(:price, price.gsub('.', '').gsub(',', '.'))
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

  def score
    score = 0
    reviews.each do |review|
      score += review.score
    end
    (score / reviews.count.to_f).round rescue false
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