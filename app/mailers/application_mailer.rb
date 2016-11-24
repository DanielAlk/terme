class ApplicationMailer < ActionMailer::Base
  default from: %("Terme" <#{ENV['notifications_mailer_username']}>)
  layout 'mailer'
end
