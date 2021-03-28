class TagMap < ApplicationRecord
  belongs_to :report
  belongs_to :tag

  validates :report_id, presence: true
  validates :tag_id, presence: true
end
