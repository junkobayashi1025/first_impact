class ApprovalMailer < ApplicationMailer
  def approval_mailer(report)
   @report = report
   @user = @report.user
   mail to: @user.email, subject: '承認のお知らせメール'
  end
end
