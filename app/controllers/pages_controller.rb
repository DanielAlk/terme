class PagesController < ApplicationController
  include Cart
  include Filterize
  before_action :authenticate_user!, only: [:cart, :checkout, :confirm]
  before_action :filterize, only: :products
  filterize object: :product, order: :price_asc, scope: :active, param: :f
  layout 'soon', only: :soon
  
  def home
    @product_categories = Category.friendly.find('products').children
  end

  def products
    @category = Category.friendly.find(params[:category_id]) rescue nil
    @products = @products.where(category: @category) if @category.present?
    @products = @products.paginate(:page => params[:page], :per_page => params[:per_page] || 12)
  end

  def product
    unless (@product = Product.friendly.find(params[:product_id])).active?
      raise ActionController::RoutingError.new("No route matches [GET] \"#{request.path}\"")
    end
    @related_products = @product.category.products.active.where.not(id: @product.id).limit(10).shuffle
  end

  def cart
    items = get_cart_items
    if items.blank?
      @cart = { count: 0 , total: 0, items: nil, products: nil }
    else
      prices = []
      product_ids = items.keys.map { |id| id.sub(/cart:\d+:/, '') }
      products = Product.find(product_ids)
      price = products.sum do |product|
        product.price * items[product.id.to_s][:quantity].to_i
      end
      @cart = { count: items.count, total: price, items: items, products: products }
    end
  end

  def checkout
  end

  def confirm
  end

  def partners
  end

  def engineering
  end

  def instalation
  end

  def about
  end

  def news
  end

  def contact
  end

  def soon
  end
end
