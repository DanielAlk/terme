json.array!(@payments) do |payment|
  json.extract! payment, :id, :user_id, :transaction_amount, :installments, :payment_method_id, :token, :mercadopago_payment, :mercadopago_payment_id, :status, :status_detail
  json.url payment_url(payment, format: :json)
end
