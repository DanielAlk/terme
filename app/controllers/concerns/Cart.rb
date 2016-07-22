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
end