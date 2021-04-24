class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         before_validation { email.downcase! }
   validates :name,  presence: true, length: { maximum: 30 }
   validates :email, presence: true, length: { maximum: 255 },
                     format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
   validates :password, presence: true, length: { minimum: 6 }

    has_many :teams
    has_many :assigns
    has_many :assign_teams, through: :assigns, source: :team
    has_many :reports
    has_many :bookmarks
    has_many :comments

    mount_uploader :icon, ImageUploader

    def self.find_or_create_by_email(email)
    user = find_or_initialize_by(email: email)
    if user.new_record?
      user.password = generate_password
      user.save
    end
    user
  end

  def self.generate_password
    SecureRandom.hex(10)
  end

  def liked_by?(report_id)
    bookmarks.where(report_id: report_id).exists?
  end

  def self.find_or_create_by_email(email)
    user = find_or_initialize_by(email: email)
    if user.new_record?
      user.password = generate_password
      user.save!
      AssignMailer.assign_mail(user.email, user.password).deliver
    end
    user
  end

  def owner_report
    owner_team = self.assign_teams.where(owner_id: self.id)
    owner_reports = Report.where(team_id: owner_team.ids, checkbox_final: false).order(created_at: :asc)
  end

  def author_report
    author_reports = self.reports.where(checkbox_final: false).order(created_at: :asc)
  end

  def request_report
    request_reports = self.reports.where(checkbox_final: false, approval: true).order(created_at: :asc)
  end

  def self.guest
    find_or_create_by!(email: 'guest1@example.com') do |user|
      user.password = user.email
      user.name = 'ゲスト1'
    end
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = 'ゲスト'
    end
  end

  def new_create_report
    Report.all.order(created_at: :desc).limit(5)
  end

  def done_report
    Report.where(checkbox_final: true).order(updated_at: :desc).limit(5)
  end

  def new_create_report_team
    team_ids = self.assign_teams.ids
    Report.where(team_id: team_ids).order(created_at: :desc).limit(5)
  end

  def done_report_team
    team_ids = self.assign_teams.ids
    Report.where(team_id: team_ids, checkbox_final: true).order(updated_at: :desc).limit(5)
  end

end
