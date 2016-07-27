module Cart
	extend ActiveSupport::Concern

	def get_cart_items
		items = {}
		item_ids = $redis.scan_each(match: current_user.cart)
		if !item_ids.nil? && (item_ids = item_ids.to_a.uniq rescue false)
		  item_ids.each do |id|
		    item = {}
		    item[:quantity] = $redis.get id
		    item[:expires_in] = $redis.ttl id
		    items[id.sub(/cart:\d+:/, '')] = item
		  end
		end
		items
	end

	def set_cart
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

	def delete_cart
		$redis.scan_each(match: current_user.cart) do |id|
			$redis.del id
		end
	end

	def authenticate_cart!
	  redirect_to root_url unless @cart.present? && @cart[:products].present? && @cart[:items].present?
	end

end