class Attachment < ApplicationRecord
  belongs_to :report
  mount_uploader :image, ImageUploader
end
