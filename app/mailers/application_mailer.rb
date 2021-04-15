class ApplicationMailer < ActionMailer::Base
  default from: ENV['OWNER_EMAIL']
  layout 'mailer'
end
