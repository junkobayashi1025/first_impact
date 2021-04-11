class UpdateReportMailer < ApplicationMailer
  def update_report_mailer(report)
   @report = report
   @users = @report.team.assign_users
   mail to: @users.pluck(:email), subject: '報告書更新のお知らせメール'
  end
end
