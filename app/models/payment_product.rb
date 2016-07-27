class PaymentProduct < ActiveRecord::Base
  belongs_to :payment
  belongs_to :product
  belongs_to :category
  has_one :image, as: :imageable, dependent: :destroy

  enum currency: [ '$' ]

  def cover(size = :thumb)
    self.image.item.url(size) rescue "product-imgs/p-#{size}.jpg"
  end
end
