class Payment < ActiveRecord::Base
  belongs_to :user
  belongs_to :zone
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :payment_products, :dependent => :destroy
  has_many :products, through: :payment_products
  validates :user, presence: true
  validates :zone, presence: true
  validates :address, presence: true
  validates :payment_products, presence: true
  validates :transaction_amount, presence: true

  serialize :mercadopago_payment
  serialize :additional_info

  def create_mercadopago_payment(cart)
    cart[:products].each do |product|
      self.payment_products.new(product_id: product.id)
    end
  	unless user.customer_id.present?
      customer = $mp.post("/v1/customers", { email: user.email })
      user.customer_id = customer['response']['id']
  		user.save
  	end
    self.additional_info = {
      items: items_for_payment_data(cart),
      payer: {
        first_name: address.fname,
        last_name: address.lname,
        phone: {
          number: address.mobile
        },
        address: {
          street_name: address.address,
          zip_code: address.zip_code
        } 
      }
    }
  	paymentData = {
  		transaction_amount: transaction_amount.to_f,
  		token: token,
  		description: "Aria Web Products",
  		installments: installments,
  		payment_method_id: payment_method_id,
  		payer: {
  			id: user.customer_id
			},
			external_reference: id,
			statement_descriptor: "Aria Web",
			notification_url: "https://www.ariaweb.com.ar/payments/notifications",
			additional_info: additional_info
  	}
  	self.mercadopago_payment = $mp.post("/v1/payments", paymentData)['response'];
    self.mercadopago_payment_id = self.mercadopago_payment['id']
    self.status = self.mercadopago_payment['status']
    self.status_detail = self.mercadopago_payment['status_detail']
    if [:approved, :in_process].include?(self.status.to_sym)
      payment_products.each do |payment_product|
        product = payment_product.product
        product.stock -= cart[:items][product.id.to_s][:quantity].to_i
        product.save
      end
    end
  end

  def friendly_status
    { approved: 'Aprobado', in_process: 'En proceso', rejected: 'Rechazado' }[status.to_sym] if status.present?
  end

  def shipment_cost
    if self.additional_info.present?
      prods = Product.select(:id, :price).find(product_ids)
      price = prods.sum do |product|
        product.price * self.item(product.id)[:quantity].to_i
      end
      self.transaction_amount - price
    end
  end

  def item(id)
    response = nil
    if self.additional_info.present?
      self.additional_info[:items].each do |item|
        response = item if item[:id] == id
      end
    end
    response
  end

  private
  	def items_for_payment_data(cart)
  		payment_products.map do |payment_product|
  			{
  				id: payment_product.product.id,
  				title: payment_product.product.title,
  				picture_url: payment_product.product.image(:medium),
  				description: payment_product.product.description,
  				category_id: 'home',
  				quantity: cart[:items][payment_product.product.id.to_s][:quantity],
  				unit_price: payment_product.product.price
  			}
  		end
  	end
end
