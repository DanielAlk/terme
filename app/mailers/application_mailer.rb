class ApplicationMailer < ActionMailer::Base
  default from: %("AriaWeb" <#{ENV['notifications_mailer_username']}>)
  layout 'mailer'
end
