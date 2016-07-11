class UserAddress < ActiveRecord::Base
  belongs_to :user
  belongs_to :zone
  acts_as_list scope: :user

  validates_length_of :address, minimum: 10, message: "debe contener al menos 10 caracteres"
  validates_presence_of :email
  validates_presence_of :fname
  validates_presence_of :lname
  validates_presence_of :zip_code
  validates_presence_of :city
  validates_presence_of :zone
  validates_presence_of :mobile
end
