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
end
