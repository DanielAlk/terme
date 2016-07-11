json.array!(@user_addresses) do |user_address|
  json.extract! user_address, :id, :address, :user_id, :email, :fname, :lname, :company, :zip_code, :city, :mobile, :zone_id, :position
  json.url user_address_url(user_address, format: :json)
end
