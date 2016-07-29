class Contact < ActiveRecord::Base
	include Filterable
	filterable search: [ :name, :email, :company, :subject, :message ]
	filterable order: [ :name, :email, :read, :created_at ]
	filterable labels: {
		order: {
			name: 'Nombre', email: 'Email', read: 'Leído', created_at: 'Fecha'
		}
	}
	validates :name, presence: true
	validates :email, presence: true
	validates :subject, presence: true
	validates :message, presence: true

	enum kind: [ :regular, :partners ]
end
