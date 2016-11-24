class Notifier < ApplicationMailer

	def notify_admin(object, special = nil)
		admin_email = ENV['notifications_mailer_to']
		case object.class.name
		when 'Contact'
			@contact = object
			mail(to: admin_email, subject: contact_subject_by_kind(@contact.kind))
		end
	end

	private
		def contact_subject_by_kind(kind)
			{
				regular: 'Contacto',
				newsletter: 'Inscripción a Newsletter',
				support: 'Pedido de soporte',
				partners: 'Club de Partners',
				ask: 'Consulta por producto'
			}[kind.try(:to_sym)]
		end

end
