json.array!(@contacts) do |contact|
  json.extract! contact, :id, :kind, :name, :email, :company, :subject, :message
  json.url contact_url(contact, format: :json)
end
