json.array!(@addresses) do |address|
  json.extract! address, :id, :address, :addressable_id, :addressable_type, :email, :fname, :lname, :company, :zip_code, :city, :mobile, :zone_id, :position
  json.url address_url(address, format: :json)
end
