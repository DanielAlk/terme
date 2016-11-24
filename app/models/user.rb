class User < ActiveRecord::Base
  include Filterable
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :addresses, -> { order(position: :asc) }, :as => :addressable, :dependent => :destroy
  has_many :reviews, :as => :reviewer, :dependent => :destroy

  filterable search: [ :fname, :lname, :email ]
  filterable order: [ :fname, :lname, :email ]
  filterable labels: { order: { fname: 'Nombre', lname: 'Apellido' } }

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
