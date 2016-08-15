class Payment < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  include Filterable
  belongs_to :user
  belongs_to :zone
  has_one :address, :as => :addressable, :dependent => :destroy
  has_many :payment_products, :dependent => :destroy
  has_many :products, through: :payment_products
  validates :user, presence: true, if: :new_record?
  validates :zone, presence: true
  validates :address, presence: true
  validates :payment_products, presence: true
  validates :transaction_amount, presence: true

  after_create :create_mercadopago_user
  after_create :save_user_address, if: :save_address?
  after_create :create_mercadopago_payment

  serialize :mercadopago_payment
  serialize :additional_info

  filterable order: [ :user_id, :status, :payment_method_id, :transaction_amount, :created_at ]
  filterable labels: { order: { user_id: 'Usuario', status: 'Estado', payment_method_id: 'Medio de págo', transaction_amount: 'Importe', created_at: 'Fecha' } }

  def self.find_mp(mercadopago_payment_id)
    mp_payment = $mp.get("/v1/payments/"+mercadopago_payment_id)
    if mp_payment['status'].try(:to_i) == 200
      payment = self.find(mp_payment['response']['external_reference'])
      if payment.present?
        payment.mercadopago_payment = mp_payment['response']
        payment.mercadopago_payment_id = payment.mercadopago_payment['id']
        payment.status = payment.mercadopago_payment['status']
        payment.status_detail = payment.mercadopago_payment['status_detail']
        if payment.status_changed? && [:pending, :authorized, :in_process].include?(payment.status_was.try(:to_sym))
          if payment.status.try(:to_sym) == :approved
            if payment.save_card && payment.user.present?
              payment.user.card = token
            end
          elsif [:rejected, :cancelled].include?(payment.status.try(:to_sym))
            payment.payment_products.each do |payment_product|
              product = payment_product.product
              product.stock += payment_product.quantity
              product.save
            end
          end
        end
        payment.save
        return payment
      end
    end
    return false
  end

  def parse_cart(cart)
    self.shipment_cost = self.zone.shipment_cost
    self.transaction_amount = cart[:total] + self.shipment_cost
    cart[:products].each do |product|
      payment_product = self.payment_products.new(product.attributes.select { |key,val| [:title, :key_code, :brand, :category_id, :description, :external_link].include? key.to_sym })
      payment_product.price = product.currency == 'u$s' ? product.price * self.dolar : product.price
      payment_product.product = product
      payment_product.quantity = cart[:items][product.id.to_s][:quantity].to_i
      payment_product.image = Image.new(item: product.images.first.item)
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
			notification_url: notifications_payments_url(protocol: 'https', host: 'ariaweb.com.ar'),
			additional_info: additional_info
  	}
  	self.mercadopago_payment = $mp.post("/v1/payments", paymentData)['response'];
    self.mercadopago_payment_id = self.mercadopago_payment['id']
    self.status = self.mercadopago_payment['status']
    self.status_detail = self.mercadopago_payment['status_detail']
    if self.status.try(:to_sym) == :approved
      if self.save_card
        user.card = token
      end
    end
    if [:approved, :pending, :authorized, :in_process].include?(self.status.try(:to_sym))
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
    friendly = { pending: 'Pendiente', approved: 'Aprobado', authorized: 'Autorizado', in_process: 'En proceso', in_mediation: 'En mediación', rejected: 'Rechazado', cancelled: 'Cancelado', refunded: 'Devuelto', charged_back: 'Contracargado' }[status.try(:to_sym)]
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
  				title: payment_product.title,
  				picture_url: payment_product.cover(:medium),
  				description: payment_product.description,
  				category_id: 'home',
  				quantity: payment_product.quantity,
  				unit_price: payment_product.price
  			}
  		end
  	end
end
