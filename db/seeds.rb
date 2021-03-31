User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.name = 'admin'
  user.admin = true
  user.password = 'admin@example.com'
  user.password_confirmation = 'admin@example.com'
end

20.times do |n|
  name = Faker::Name.name
  email = Faker::Internet.email
  password = email
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password,
               )
end
