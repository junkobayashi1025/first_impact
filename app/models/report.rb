class Report < ApplicationRecord
  acts_as_taggable
  belongs_to :user
  belongs_to :team
  has_many :bookmarks, -> {order(created_at: :desc)}, dependent: :destroy
  has_many :comments,                                 dependent: :destroy
  has_many :attachments,                              dependent: :destroy
  accepts_nested_attributes_for :attachments, allow_destroy: true, reject_if: :all_blank

  validates :title,            presence: true, length: { maximum: 30 }
  validates :accrual_date,     presence: true
  validates :site_of_occurrence,               length: { maximum: 30 }
  validates :trouble_content,  presence: true
  validates :first_aid,        presence: true
  validates :interim_measures, presence: true
  validate  :accrual_date_check
  validate  :confirmed_date_check

  scope :sort_by_deadline_date_asc, lambda { all.sort_by(&:deadline_date) }
  scope :sort_by_deadline_date_desc, lambda { all.sort_by(&:deadline_date).reverse }

  def accrual_date_check
    if self.accrual_date > Date.today
      errors.add(:accrual_date, "は#{Date.today}以前の日付を設定してください")
    end
  end

  def confirmed_date_check
    if self.checkbox_interim && self.confirmed_date.present? && self.accrual_date + 14.day > self.confirmed_date
      errors.add(:confirmed_date, "は3.恒久対策(提出〆切)以降の日付を設定してください")
    end
  end

  def build_attachment_for_form
   self.attachments.build if saved_attachments.length < 5 && unsaved_attachments.length == 0
  end

  def saved_attachments
   self.attachments.select(&:id)
  end

  def unsaved_attachments
   self.attachments.select { |attachment| attachment.id.nil? }
  end

  def bookmarked_by(user)
    Bookmark.find_by(user_id: user.id, report_id: id)
  end

  def step_string
    if self.checkbox_interim && self.checkbox_first && self.confirmed_date.present?
      return self.update(step:"3: 有効性の確認", due: self.confirmed_date)
    elsif self.checkbox_interim && self.checkbox_first
      return self.update(step:"3: 有効性の確認", due: nil)
    elsif self.checkbox_first
      return self.update(step:"2: 中間報告", due: self.accrual_date + 14.day )
    else
      return self.update(step:"1: 第一報告", due: self.accrual_date + 7.day )
    end
  end

  def status_string
    if self.approval
      return self.update(status: "承認依頼中")
    else
      return self.update(status: "作成中")
    end
  end
end
