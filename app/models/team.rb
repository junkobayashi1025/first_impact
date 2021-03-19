class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :user
  has_many :assigns, dependent: :destroy
  has_many :team_members, through: :assigns, source: :team

  mount_uploader :icon, ImageUploader

end
