class Team < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :owner, class_name: 'User', foreign_key: :owner_id
  belongs_to :charge_in_person, class_name: 'User', foreign_key: :charge_in_person_id
  has_many :assigns, dependent: :destroy
  has_many :assign_users, through: :assigns, source: :user

  mount_uploader :icon, ImageUploader

  def invite_member(user)
    assigns.create(user: user)
  end
end
