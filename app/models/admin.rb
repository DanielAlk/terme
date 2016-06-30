class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def administrator?
  	self.profile == 'administrator'
  end

  def regular?
  	self.profile == 'regular'
  end
end
