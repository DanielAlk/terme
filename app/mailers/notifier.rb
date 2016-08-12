class Notifier < ApplicationMailer

	def notify_admin(object)
		admin_email = ENV['notifications_mailer_to']
		case object.class.name
		when 'Contact'
			@contact = object
			mail(to: admin_email, subject: 'Contacto en Aria Web')
		end
	end

end
