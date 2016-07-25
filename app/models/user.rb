class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :addresses, -> { order(position: :asc) }, :as => :addressable, :dependent => :destroy
  has_many :reviews, :as => :reviewer, :dependent => :destroy
  has_many :payments

  def cart_count
    $redis.scan_each(match: "cart:#{id}:*").to_a.uniq.count
  end

  def cart(product_id = '*')
  	"cart:#{id}:#{product_id}"
  end

  def address
  	addresses.first
  end

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

end
