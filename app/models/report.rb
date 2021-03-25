class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum search_item: {タイトル: 1, チーム名: 2, 責任者: 3, 担当者: 4}

  scope :sort_by_deadline_date_asc, lambda { all.sort_by(&:deadline_date) }
  scope :sort_by_deadline_date_desc, lambda { all.sort_by(&:deadline_date).reverse }

  def deadline_date
    return self.confirmed_date || self.accrual_date
  end

  def step
    return 0
  end

  def step_string
    case self.step
    when 0: return "完了"
    end
  end
end
