json.array!(@zones) do |zone|
  json.extract! zone, :id, :title, :ancestry, :shipment_cost
  json.url zone_url(zone, format: :json)
end
