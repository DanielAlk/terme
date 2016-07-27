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

  after_create :create_mercadopago_user
  after_create :save_user_address, if: :save_address?
  after_create :create_mercadopago_payment

  serialize :mercadopago_payment
  serialize :additional_info

  def parse_cart(cart)
    cart[:products].each do |product|
      self.payment_products.new(product_id: product.id, quantity: cart[:items][product.id.to_s][:quantity].to_i, unit_price: product.price)
    end
  end

  def create_mercadopago_user
    user.create_mercadopago_user
  end

  def save_user_address
    user.addresses.create(self.address.attributes.select { |key,val| !['id', 'addressable_type', 'addressable_id'].include? key })
  end
  
  def create_mercadopago_payment
    self.additional_info = {
      items: additional_info_items,
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
			statement_descriptor: "Compra en Aria Web",
			notification_url: "https://ariaweb.com.ar/payments/notifications",
			additional_info: additional_info
  	}
    self.shipment_cost = self.zone.shipment_cost
  	self.mercadopago_payment = $mp.post("/v1/payments", paymentData)['response'];
    self.mercadopago_payment_id = self.mercadopago_payment['id']
    self.status = self.mercadopago_payment['status']
    self.status_detail = self.mercadopago_payment['status_detail']
    if [:approved, :in_process].include?(self.status.to_sym)
      if self.save_card
        user.card = token
      end
      payment_products.each do |payment_product|
        product = payment_product.product
        product.stock -= payment_product.quantity
        product.save
      end
    elsif self.status == '400' && self.mercadopago_payment['cause'][0]['code'] == 2002 #customer_not_found
      user.update_attribute(:customer_id, nil)
    end
    save
  end

  def friendly_status
    friendly = { approved: 'Aprobado', in_process: 'En proceso', rejected: 'Rechazado' }[status.try(:to_sym)]
    if friendly.blank?
      friendly = 'No procesado'
    end
    friendly
  end

  private
  	def additional_info_items
  		payment_products.map do |payment_product|
  			{
  				id: payment_product.product.id,
  				title: payment_product.product.title,
  				picture_url: payment_product.product.image(:medium),
  				description: payment_product.product.description,
  				category_id: 'home',
  				quantity: payment_product.quantity,
  				unit_price: payment_product.unit_price
  			}
  		end
  	end
end
