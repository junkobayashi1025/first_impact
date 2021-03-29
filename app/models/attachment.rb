class Attachment < ApplicationRecord
  belongs_to :report
  mount_uploader :content, ImageUploader
end
