class Notifier < ApplicationMailer

	def notify_admin(object, special: nil)
		admin_email = ENV['notifications_mailer_to']
		case object.class.name
		when 'Contact'
			@contact = object
			mail(to: admin_email, subject: 'Contacto en Aria Web')
		when 'Payment'
			@payment = object
			@mercadopago_notification = special == :mercadopago_notification
			mail(to: admin_email, subject: 'Compra en Aria Web')
		end
	end

	def notify_user(object, special: nil)
		case object.class.name
		when 'Payment'
			@payment = object
			@mercadopago_notification = special == :mercadopago_notification
			mail(to: @payment.user.email, subject: 'Resumen de compra AriaWeb')
		end
	end

end
