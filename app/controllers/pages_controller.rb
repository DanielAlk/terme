class PagesController < ApplicationController
  include Filterize
  before_action :filterize, only: [:products, :tag]
  filterize object: :product, order: :special_desc, scope: :active, param: :f
  layout 'soon', only: :soon
  
  def home
    @product_categories = Category.friendly.find('products').children
    @news = Article.limit(Article.shape_highlited(:news)).news.order(position: :asc)
  end

  def products_and_services
    @categories = Category.friendly.find('products').children
    @articles = Article.services.order(position: :asc)
  end

  def services_index
    @articles = Article.services.order(position: :asc)
  end

  def products
    if params[:category_id].present?
      @category = Category.friendly.find(params[:category_id])
      @products = @products.where(category: @category.subtree.map{|c| c})
      @products = @products.paginate(:page => params[:page], :per_page => params[:per_page] || 12)
    elsif params[:f].present?
      @products = @products.paginate(:page => params[:page], :per_page => params[:per_page] || 12)
    else
      @product_categories = Category.friendly.find('products').children
    end
  end

  def tag
    @tag = Tag.friendly.find(params[:tag_id])
    @products = @products.where(id: Tagging.where(taggable_type: 'Product', tag_id: @tag.id ).map(&:taggable_id))
    @products = @products.paginate(:page => params[:page], :per_page => params[:per_page] || 12)
    render :products
  end

  def product
    @product = Product.active.friendly.find(params[:product_id])
    @related_products = @product.category.products.active.where.not(id: @product.id).limit(10).shuffle
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
    @articles = Article.news.order(position: :asc).paginate(:page => params[:page], :per_page => 2)
    respond_to do |format|
      format.html
      format.js
    end
  end

  def article
    @article = Article.friendly.find(params[:article_id])
  end

  def contact
    if user_signed_in?
      @contact = Contact.new(name: current_user.name, email: current_user.email)
    else
      @contact = Contact.new
    end
  end

  def soon
  end
end
