class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :bookmarks, -> {order(created_at: :desc)}, dependent: :destroy
  has_many :comments,  dependent: :destroy
  # accepts_nested_attributes_for :attachments

  enum search_item: {タイトル: 1, チーム名: 2, 責任者: 3, 担当者: 4}

  scope :sort_by_deadline_date_asc, lambda { all.sort_by(&:deadline_date) }
  scope :sort_by_deadline_date_desc, lambda { all.sort_by(&:deadline_date).reverse }

  def deadline_date
    return self.confirmed_date || self.accrual_date
  end

  def bookmarked_by(user)
    Bookmark.find_by(user_id: user.id, report_id: id)
  end

  # def step
  #   return 0
  # end
  #
  # def step_string
  #   case self.step
  #   when 0: return "完了"
  #   end
  # end
end
