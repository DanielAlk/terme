json.array!(@categories) do |category|
  json.extract! category, :id, :title, :ancestry, :fixed, :slug
  json.url category_url(category, format: :json)
end
