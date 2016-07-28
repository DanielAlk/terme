class PagesController < ApplicationController
  include Cart
  include Filterize
  before_action :authenticate_user!, only: [:cart, :checkout, :confirm]
  before_action :set_cart, only: [:cart, :checkout]
  before_action :filterize, only: [:products, :tag]
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

  def tag
    @tag = Tag.friendly.find(params[:tag_id])
    @products = @products.where(id: Tagging.where(taggable_type: 'Product', tag_id: @tag.id ).map(&:taggable_id))
    @products = @products.paginate(:page => params[:page], :per_page => params[:per_page] || 12)
    render :products
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
    redirect_to cart_page_url if @cart[:items].blank?
  end

  def confirm
  end

  def partners
  end

  def services
    @article = Article.friendly.find(params[:article_id])
  end

  def about
    @article = Article.about.order(position: :asc).first
  end

  def news
  end

  def contact
  end

  def soon
  end
end
