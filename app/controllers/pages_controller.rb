class PagesController < ApplicationController
  include Filterize
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
