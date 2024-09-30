# メインのサンプルユーザー
User.create!(user_name: "sososo",
             email: "test@test.com",
             password: "password",
             password_confirmation: "password",
             goal: "Do my best",
             goal_due_date: Date.today,
            )

# 追加のユーザーをまとめて生成する
99.times do |n|
  user_name = Faker::Name.name
  email = "test-#{n+1}@test.com"
  password = "password"
  sentence = Faker::Lorem.sentence
  day = Date.today + n
  User.create!(user_name: user_name,
               email: email,
               password: password,
               password_confirmation: password,
               goal: sentence,
               goal_due_date: day
              )
end

