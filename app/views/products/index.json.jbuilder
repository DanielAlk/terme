json.array!(@products) do |product|
  json.extract! product, :id, :title, :status, :special, :key_code, :brand, :category_id, :stock, :price, :currency, :width_mm, :height_mm, :depth_mm, :description, :characteristics, :data_sheet, :data_sheet_file, :information, :external_link, :slug
  json.url product_url(product, format: :json)
end
