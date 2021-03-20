class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :user
  has_many :assigns, dependent: :destroy
  has_many :assign_users, through: :assigns, source: :user

  mount_uploader :icon, ImageUploader

end
