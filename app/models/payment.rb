class Payment < ActiveRecord::Base
  belongs_to :user
  has_many :products, through: :payment_product
  validates :user, presence: true
  validates :products, presence: true

  serialize :mercadopago_payment
end
