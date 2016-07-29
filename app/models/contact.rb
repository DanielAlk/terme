class Contact < ActiveRecord::Base
	include Filterable
	filterable search: [ :name, :email, :company, :subject, :message ]
	filterable order: [ :name, :email, :read, :created_at ]
	filterable labels: {
		order: {
			name: 'Nombre', email: 'Email', read: 'Leído', created_at: 'Fecha'
		}
	}
	validates :name, presence: true, unless: :newsletter?
	validates :subject, presence: true, unless: :newsletter?
	validates :message, presence: true, unless: :newsletter?
	validates :email, uniqueness: { scope: :kind, message: 'Ya estás suscripto al newsletter' }, if: :newsletter?
	validates :email, presence: true

	before_save :mark_as_read, if: :newsletter?

	enum kind: [ :regular, :newsletter, :support ]

	private
		def mark_as_read
			self.read = true
		end

end
