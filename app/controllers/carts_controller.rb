class CartsController < ApplicationController
  before_action :authenticate_user!

  def show
    items = {}
    item_ids = $redis.scan_each(match: current_user.cart)
    if !item_ids.nil? && (items_ids = item_ids.to_a.uniq rescue false)
      item_ids.each do |id|
        item = {}
        item[:quantity] = $redis.get id
        item[:expires_in] = $redis.ttl id
        items[id.sub(/cart:\d+:/, '')] = item
      end
    end
    if items.blank?
      @cart = { count: 0 , total: 0, items: nil, products: nil }
    else
      prices = []
      product_ids = items.keys.map { |id| id.sub(/cart:\d+:/, '') }
      products = Product.select(:id, :price, :stock).find(product_ids)
      price = products.sum do |product|
        product.price * items[product.id.to_s][:quantity].to_i
      end
      @cart = { count: items.count, total: price, items: items, products: products }
    end
  end

  def add
    if product_params[:quantity] == 0 || product_params[:quantity] == '0'
      remove
    else
      $redis.set current_user.cart(product_params[:id]), product_params[:quantity]
      $redis.expire current_user.cart(product_params[:id]), 600 #expire in 10 minutes
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
end