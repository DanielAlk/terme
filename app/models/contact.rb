class Contact < ActiveRecord::Base
	include Filterable
	belongs_to :contactable, polymorphic: true
	filterable search: [ :name, :email, :company, :subject, :message ]
	filterable order: [ :name, :email, :read, :created_at ]
	filterable labels: {
		order: {
			name: 'Nombre', email: 'Email', read: 'Leído', created_at: 'Fecha'
		}
	}
	validates :name, presence: true, unless: :newsletter_or_partners?
	validates :subject, presence: true, unless: :newsletter_or_partners?
	validates :message, presence: true, unless: :newsletter_or_partners?
	validates :email, uniqueness: { scope: :kind, message: 'Ya estás suscripto al newsletter' }, if: :newsletter?
	validates :email, uniqueness: { scope: :kind, message: 'Ya sos miembro del Club Partners de Terme' }, if: :partners?
	validates :email, presence: true

	before_save :mark_as_read, if: :newsletter_or_partners?
	before_save :check_kind, if: Proc.new { |c| c.contactable.present? }

	enum kind: [ :regular, :newsletter, :support, :partners, :ask ]

	def newsletter_or_partners?
		newsletter? || partners?
	end

	private
		def mark_as_read
			self.read = true
		end

		def check_kind
			self.kind = :ask
		end

end
