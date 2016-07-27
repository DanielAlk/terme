json.array!(@websites) do |website|
  json.extract! website, :id, :address, :phone, :mobile, :email, :facebook, :twitter, :google, :linkedin, :youtube
  json.url website_url(website, format: :json)
end
