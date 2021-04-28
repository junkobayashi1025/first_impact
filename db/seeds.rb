# User.find_or_create_by!(email: 'admin@example.com') do |user|
#   user.name = 'admin'
#   user.admin = true
#   user.password = 'admin@example.com'
#   user.password_confirmation = 'admin@example.com'
# end

# 20.times do |n|
#   name = Faker::Name.name
#   email = Faker::Internet.email
#   password = email
#   User.create!(name: name,
#                email: email,
#                password: password,
#                password_confirmation: password,
#                )
# end

require "csv"
require "date"

CSV.foreach('db/sample_date/user_sample.csv') do |info|
  User.create(:name => info[0], :email => info[1], :password => info[2], :admin => info[3], :user_id => info[4])
end

CSV.foreach('db/sample_date/team_sample.csv') do |info|
  Team.create(:name => info[0], :remark => info[1], :owner_id => info[2], :team_id => info[3])
end

CSV.foreach('db/sample_date/assign_sample.csv') do |info|
  Assign.create(:user_id => info[0], :team_id => info[1])
end

CSV.foreach('db/sample_date/report_sample.csv') do |info|
  Report.create(:title => info[0],
                :user_id => info[1],
                :team_id => info[2],
                :accrual_date => info[3],
                :site_of_occurrence => info[4],
                :trouble_content => info[5],
                :first_aid => info[6],
                :interim_measures => info[7],
                :permanent_measures => info[8],
                :confirmation_of_effectiveness => info[9],
                :checkbox_first => info[10],
                :checkbox_interim => info[11],
                :checkbox_final => info[12],
                :approval => info[13],
                :step => info[14],
                :status => info[15],
                :due => info[16],
                :owner => info[17],
                :author => info[18])
end
