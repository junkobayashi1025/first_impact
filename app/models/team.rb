class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  has_many :assigns, dependent: :destroy
  has_many :assign_users, through: :assigns, source: :user
  has_many :reports

  validates :name, presence: true, length: { maximum: 30 }

  mount_uploader :icon, ImageUploader

  def invite_member(user)
    assigns.create(user: user)
  end

  def prepared_report
    prepared_reports = self.reports.where(checkbox_final: false, approval: false).order(created_at: :asc)
  end

  def request_report
    request_reports = self.reports.where(checkbox_final: false, approval: true).order(created_at: :asc)
  end

  def new_create_report
    Report.all.order(created_at: :desc).limit(5)
  end

  def done_report
    Report.where(checkbox_final: true).order(updated_at: :desc).limit(5)
  end

  def new_create_report_team
    Report.where(team_id: self.id).order(created_at: :desc).limit(5)
  end

  def done_report_team
    Report.where(team_id: self.id, checkbox_final: true).order(updated_at: :desc).limit(5)
  end

  def author_report_in_team

    Report.where(team_id: self.id, user_id: self.assign_users.ids, checkbox_final: false)
  end
end
