# メインのサンプルユーザー
User.create!(user_name: "sososo",
             email: "test@test.com",
             password: "password",
             password_confirmation: "password",
             goal: "Do my best",
             goal_due_date: Date.today,
             admin: true
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

# avatarsの追加
avatars = [
  { avatar_name: '犬1', required_level: 1, image_name: 'dog1.jpg' },
  { avatar_name: '犬2', required_level: 3, image_name: 'dog2.jpg' },
  { avatar_name: '猫', required_level: 5, image_name: 'cat.jpg' },
  { avatar_name: '牛', required_level: 7, image_name: 'cattle.jpg' },
  { avatar_name: 'カメレオン', required_level: 8, image_name: 'chameleon.jpg' },
  { avatar_name: 'チーター', required_level: 10, image_name: 'cheetah.jpg' },
  { avatar_name: 'ワニ', required_level: 15, image_name: 'crocodile.jpg' },
  { avatar_name: 'イルカ', required_level: 20, image_name: 'dolphin.jpg' },
  { avatar_name: 'ゾウ', required_level: 25, image_name: 'elephant.jpg' },
  { avatar_name: 'キリン', required_level: 30, image_name: 'giraffe.jpg' },
  { avatar_name: 'ハムスター', required_level: 35, image_name: 'hamster.jpg' },
  { avatar_name: 'カバ', required_level: 40, image_name: 'hippopotamus.jpg' },
  { avatar_name: '馬', required_level: 45, image_name: 'horse.jpg' },
  { avatar_name: 'ライオン', required_level: 50, image_name: 'lion.jpg' },
  { avatar_name: 'コアラ', required_level: 55, image_name: 'koala.jpg' },
  { avatar_name: 'カワウソ', required_level: 60, image_name: 'otter.jpg' },
  { avatar_name: 'インコ', required_level: 65, image_name: 'parakeet.jpg' },
  { avatar_name: 'クジャク', required_level: 70, image_name: 'peacock.jpg' },
  { avatar_name: 'ハト', required_level: 75, image_name: 'pigeon1.jpg' },
  { avatar_name: 'ハト(飛)', required_level: 80 , image_name: 'pigeon2.jpg' },
  { avatar_name: 'うさぎ', required_level: 85, image_name: 'rabbit.jpg' },
  { avatar_name: 'アライグマ', required_level: 90, image_name: 'raccoon.jpg' },
  { avatar_name: 'サメ', required_level: 100, image_name: 'shark.jpg' },
]

avatars.each do |avatar_data|
  # 存在する場合は作らない
  Avatar.find_or_create_by!(avatar_name: avatar_data[:avatar_name]) do |avatar|
    avatar.required_level = avatar_data[:required_level]
    avatar.image_name = avatar_data[:image_name]
  end
end