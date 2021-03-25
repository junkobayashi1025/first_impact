class Report < ApplicationRecord
  belongs_to :user
  belongs_to :team

  enum search_item: {タイトル: 1, チーム名: 2, 責任者: 3, 担当者: 4}
end
