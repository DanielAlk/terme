json.array!(@articles) do |article|
  json.extract! article, :id, :shape, :status, :title, :subtitle, :description, :text, :link, :image, :position, :slug
  json.url article_url(article, format: :json)
end
