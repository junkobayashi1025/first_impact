class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :charge_in_person, class_name: 'User', foreign_key: :charge_in_person_id
  has_many :assigns, dependent: :destroy
  has_many :assign_users, through: :assigns, source: :user
  has_many :reports

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

  def done_report
    done_reports = self.reports.where(checkbox_final: true).order(updated_at: :asc)
  end
end
