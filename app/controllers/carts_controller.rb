class CartsController < ApplicationController
  before_action :authenticate_user!
  include Cart

  def show
    items = get_cart_items
    if items.blank?
      @cart = { count: 0 , total: 0, items: nil, products: nil }
    else
      prices = []
      product_ids = items.keys.map { |id| id.sub(/cart:\d+:/, '') }
      products = Product.select(:id, :title, :price, :stock).find(product_ids).map do |p|
        { id: p.id, title: p.title, price: p.price, stock: p.stock_available_to_user(current_user.id) }
      end
      price = products.sum do |product|
        product[:price] * items[product[:id].to_s][:quantity].to_i
      end
      @cart = { count: items.count, total: price, items: items, products: products }
    end
  end

  def stock
    product = Product.select(:id, :stock).find(product_params[:id])
    @product = { stock: product.stock_available_to_user(current_user.id) }
  end

  def add
    if params[:products].present?
      params[:products].each do |key, product|
        add_to_cart(product[:id], product[:quantity])
      end
      render json: current_user.cart_count, status: 200
    elsif product_params[:quantity] == 0 || product_params[:quantity] == '0'
      remove
    else
      add_to_cart(product_params[:id], product_params[:quantity])
      render json: current_user.cart_count, status: 200
    end
  end

  def remove
    $redis.del current_user.cart(product_params[:id])
    render json: current_user.cart_count, status: 200
  end

  private
    def product_params
      params.require(:product).permit(:id, :quantity)
    end

    def add_to_cart(product_id, quantity)
      product = Product.select(:id, :stock).find(product_id)
      stock = product.stock_available_to_user(current_user.id)
      quantity = quantity.to_i > stock ? stock : quantity.to_i
      if quantity > 0
        $redis.set current_user.cart(product_id), quantity
        $redis.expire current_user.cart(product_id), 600 #expire in 10 minutes
      end
    end
end