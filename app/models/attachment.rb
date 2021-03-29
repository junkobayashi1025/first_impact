class Attachment < ApplicationRecord
  belongs_to :report
  mount_uploaders :contents, ImageUploader
end
