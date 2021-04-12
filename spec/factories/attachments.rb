FactoryBot.define do
  factory :attachment, class: Attachment do
    image { "#{Rails.root}/spec/files/icon1.jpg" }
  end
end
