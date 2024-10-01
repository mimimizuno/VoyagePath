# 本番環境用のseed
# RAILS_ENV=production rails db:seed:load DIR=db/seeds_production.rb

avatars = [
  { avatar_name: 'Warrior', required_level: 1, image_name: 'warrior.png' },
  { avatar_name: 'Mage', required_level: 5, image_name: 'mage.png' },
  { avatar_name: 'Rogue', required_level: 10, image_name: 'rogue.png' }
]

avatars.each do |avatar_data|
  # 存在する場合は作らない
  Avatar.find_or_create_by!(avatar_name: avatar_data[:avatar_name]) do |avatar|
    avatar.required_level = avatar_data[:required_level]
    avatar.image_name = avatar_data[:image_name]
  end
end