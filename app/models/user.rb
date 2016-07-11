class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_addresses

	def name(option = nil)
		if self.fname.present? && self.lname.present?
			case option.to_s.to_sym
			when :first
				self.fname
			when :last
				self.lname
			else
				self.fname + ' ' + self.lname
			end
		else
			self.email[/[^@]+/]
		end
	end

	def addresses
		user_addresses.order(position: :asc).map &:address
	end

end
