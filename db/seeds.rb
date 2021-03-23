User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'admin'
  user.admin = true
  user.password = 'password'
  user.password_confirmation = 'password'
end

20.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = Faker::Internet.email
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end
