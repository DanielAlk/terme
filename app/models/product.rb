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

  filterable scopes: [ :status, :brand, :category ]
  filterable search: [ :title, :key_code, :characteristics, :data_sheet, :information ]
  filterable range: { price: { scoped: :currency } }
  filterable order: [ :status, :title, :brand, :category, :price, :key_code, :created_at, :updated_at ]
  filterable_label scopes: {status: {draft: 'Borrador', active: 'Activa', paused: 'Pausada'}}
  filterable_label order: {status: 'Status', title: 'Título', brand: 'Marca', category: 'Categoría', price: 'Precio', key_code: 'Código', created_at: 'Creación', updated_at: 'Modificación'}

  enum status: [ :draft, :active, :paused, :trash ]
  enum currency: [ '$', 'u$s' ]

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