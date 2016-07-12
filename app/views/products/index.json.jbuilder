json.array!(@products) do |product|
  json.extract! product, :id, :title, :status, :key_code, :brand, :category_id, :stock, :price, :currency, :dimensions, :description, :characteristics, :data_sheet, :information, :external_link, :slug
  json.url product_url(product, format: :json)
end
