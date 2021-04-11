FactoryBot.define do
  factory :report, class: Report do
    title { "report" }
    accrual_date { Time.current }
    trouble_content { "trouble_content" }
    first_aid {"first_aid"}
    interim_measures { "interim_measures" }
  end

  factory :report1, class: Report do
    title { "report1" }
    accrual_date { Time.current + 30.days }
    trouble_content { "1_trouble_content" }
    first_aid {"1_first_aid"}
    interim_measures { "1_interim_measures" }
  end
end
