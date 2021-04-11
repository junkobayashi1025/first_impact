FactoryBot.define do
  factory :user, class: User do
    name { "admin" }
    email { "admin@example.com" }
    password { "password" }
    password_confirmation {"password"}
    admin { true }
  end

  factory :user1, class: User do
    name { "user1" }
    email { "user1@example.com" }
    password { "password1" }
    password_confirmation {"password1"}
    admin { false }
  end

  factory :user2, class: User do
    name { "user2" }
    email { "user2@example.com" }
    password { "password2" }
    password_confirmation {"password2"}
    admin { false }
  end
end
