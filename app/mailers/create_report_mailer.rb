class CreateReportMailer < ApplicationMailer
  def create_report_mailer(team, report)
   @report = report
   @team = team
   @users = @team.assign_users
   mail to: @users.pluck(:email), subject: '新規報告書作成のお知らせメール'
  end
end
