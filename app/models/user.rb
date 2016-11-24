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

  def card=(token)
    $mp.post("/v1/customers/#{customer_id}/cards", { token: token })
  end

  def delete_card(card_id)
    $mp.delete("/v1/customers/#{customer_id}/cards/#{card_id}")
  end

  def cards
    request = $mp.get("/v1/customers/#{customer_id}/cards")
    if request["status"] == "200"
      request["response"]
    end
  end

  def create_mercadopago_user
    unless self.customer_id.present?
      customer = $mp.post("/v1/customers", { email: email })
      self.customer_id = customer['response']['id']
      if self.customer_id.blank?
        customer = $mp.get("/v1/customers/search", { email: email })
        self.customer_id = customer['response']['results'][0]['id']
      end
      self.save
    end
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
