class Attachment < ApplicationRecord
  belongs_to :report
  mount_uploaders :image, ImageUploader
end
