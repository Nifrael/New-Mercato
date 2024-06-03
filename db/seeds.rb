# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'net/http'
require 'json'
require "open-uri"
require "nokogiri"

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

Booking.destroy_all
Player.destroy_all
User.destroy_all

puts "----------------------------------------------------------------"
puts "Records destroyed"
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Creating users..."
puts "----------------------------------------------------------------"

albert = User.create(
first_name: 'Albert',
last_name: 'Nikolli',
email: 'sarabanda.sarab@gmail.com',
password: 'azerty1234',
avatar: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Jiří_Kylián_2020.jpg'
)

julien = User.create(
first_name: 'Julien',
last_name: 'Marchand',
email: 'liverpool.liver@gmail.com',
password: 'azerty1234',
avatar: 'https://upload.wikimedia.org/wikipedia/commons/8/81/Jürgen_Klopp%2C_Liverpool_vs._Chelsea%2C_UEFA_Super_Cup_2019-08-14_04.jpg'
)

ricardo = User.create(
first_name: 'Ricardo',
last_name: 'Canas',
email: 'benfica.benfi@gmail.com',
password: 'azerty1234',
avatar: 'https://upload.wikimedia.org/wikipedia/commons/7/7b/Mourinho_in_Moscow.jpg'
)

puts "----------------------------------------------------------------"
puts "#{User.count} Users created"
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Creating players..."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Creating players of liverpool"
puts "----------------------------------------------------------------"

position_mapping = {
  "Centre-Forward" => "Attaquant",
  "Goalkeeper" => "Gardien",
  "Centre-Back" => "Défenseur",
  "Left Winger" => "Attaquant",
  "Second Striker" => "Attaquant",
  "Right-Back" => "Défenseur",
  "Defensive Midfield" => "Milieu",
  "Central Midfield" => "Milieu",
  "Attacking Midfield" => "Milieu",
  "Right Winger" => "Attaquant",
  "Left-Back" => "Défenseur",
  "Right Midfield" => "Milieu",
  "Left Midfield" => "Milieu"
}

url_liverpool = 'https://transfermarkt-api.fly.dev/clubs/31/players'
uri = URI(url_liverpool)
response = Net::HTTP.get(uri)
data = JSON.parse(response)
players = data['players']

players.each do |player|
  if player['marketValue'].present?
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Liverpool',
      market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
      price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
      owner_id: julien[:id],
      photo: ''
    )
  else
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Liverpool',
      market_value: 0,
      price_per_day: 0,
      owner_id: julien[:id],
      photo: ''
    )
  end
end

puts "----------------------------------------------------------------"
puts "Creating players of lisboa"
puts "----------------------------------------------------------------"

url_lisboa = 'https://transfermarkt-api.fly.dev/clubs/294/players'
uri = URI(url_lisboa)
response = Net::HTTP.get(uri)
data = JSON.parse(response)
players = data['players']

players.each do |player|
  if player['marketValue'].present?
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Benfica Lisbonne',
      market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
      price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
      owner_id: ricardo[:id],
      photo: ''
    )
  else
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Benfica Lisbonne',
      market_value: 0,
      price_per_day: 0,
      owner_id: ricardo[:id],
      photo: ''
    )
  end
end

puts "----------------------------------------------------------------"
puts "Creating players of juventus"
puts "----------------------------------------------------------------"

url_juventus = 'https://transfermarkt-api.fly.dev/clubs/506/players'
uri = URI(url_juventus)
response = Net::HTTP.get(uri)
data = JSON.parse(response)
players = data['players']

players.each do |player|
  if player['marketValue'].present?
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Juventus',
      market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
      price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
      owner_id: albert[:id],
      photo: ''
    )
  else
    Player.create(
      id: player['id'],
      name: player['name'],
      position: position_mapping[player['position']],
      age: player['age'],
      nationality: JSON.parse(player['nationality'].to_s).join(', '),
      height: player['height'],
      foot: player['foot'] == 'right' ? 'droit' : 'gauche',
      club: 'Juventus',
      market_value: 0,
      price_per_day: 0,
      owner_id: albert[:id],
      photo: ''
    )
  end
end

players_created = Player.all
players_created.each do |player|
  puts "Adding photo to #{player.name}"
  top_url = "https://www.transfermarkt.com/-/profil/spieler/#{player.id}"
  doc = Nokogiri::HTML.parse(URI.parse(top_url).open("User-Agent" => USER_AGENT).read)
  photos = doc.search(".data-header__profile-image")
  photo_url = photos.attribute("src").value
  player.update(img: photo_url)
  puts "Photo added to #{player.name}"
end

puts "----------------------------------------------------------------"
puts "#{Player.count} players creeated"
puts "----------------------------------------------------------------"

puts "Seed done"
