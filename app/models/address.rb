class Address < ActiveRecord::Base
  belongs_to :addressable, polymorphic: true
  belongs_to :zone
  acts_as_list scope: :addressable

  validates :address, length: { minimum: 10, message: "debe contener al menos 10 caracteres" }
  validates :email, :fname, :lname, :zip_code, :city, :zone, :mobile, presence: true
  
  with_options if: Proc.new { |a| a.addressable_type == 'User' } do |a|
    a.validates :address, length: { minimum: 10 }, uniqueness: { scope: [:addressable_id, :addressable_type], message: "Ya agregaste esa dirección" }
    a.validates :zip_code, uniqueness: { scope: [:addressable_id, :addressable_type], message: "Ya agregaste una dirección con el mismo código postal" }
  end
end