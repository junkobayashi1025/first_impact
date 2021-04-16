FactoryBot.define do
  factory :report, class: Report do
    title { "report" }
    accrual_date { Date.today  }
    trouble_content { "trouble_content" }
    first_aid {"first_aid"}
    interim_measures { "interim_measures" }
    permanent_measures { "" }
    confirmation_of_effectiveness { "" }
    step { "1: 第一報" }
    status { "作成中" }
    due { Date.today + 7.days }
  end

  factory :report1, class: Report do
    title { "検索テスト" }
    accrual_date { Date.today }
    trouble_content { "1_trouble_content" }
    first_aid {"1_first_aid"}
    interim_measures { "1_interim_measures" }
    permanent_measures { "" }
    confirmation_of_effectiveness { "" }
    step { "1: 第一報" }
    status { "作成中" }
    due { Date.today + 7.days }
  end
end
