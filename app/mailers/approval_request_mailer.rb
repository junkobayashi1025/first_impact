class ApprovalRequestMailer < ApplicationMailer
  def approval_request_mailer(report)
   @report = report
   @user = @report.team.owner
   mail to: @user.email, subject: '承認依頼のお知らせメール'
  end
end
