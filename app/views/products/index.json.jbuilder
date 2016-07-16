json.array!(@products) do |product|
  json.extract! product, :id, :title, :status, :special, :key_code, :brand, :category_id, :stock, :price, :currency, :width_cm, :height_cm, :depth_cm, :description, :characteristics, :data_sheet, :information, :external_link, :slug
  json.url product_url(product, format: :json)
end
