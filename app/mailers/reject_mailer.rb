class RejectMailer < ApplicationMailer
  def reject_mailer(report)
   @report = report
   @user = @report.user
   mail to: @user.email, subject: '再提出のお知らせメール'
  end
end
