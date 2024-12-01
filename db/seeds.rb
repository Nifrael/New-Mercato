# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# require 'net/http'
# require 'json'
# require "open-uri"
# require "nokogiri"

# USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

# Booking.destroy_all
# Player.destroy_all
# User.destroy_all

# puts "----------------------------------------------------------------"
# puts "Records destroyed"
# puts "----------------------------------------------------------------"

# puts "----------------------------------------------------------------"
# puts "Creating users..."
# puts "----------------------------------------------------------------"

# User.create(
# first_name: 'Julien',
# last_name: 'Marchand',
# email: 'liverpool.liver@gmail.com',
# password: 'azerty1234',
# avatar: 'https://upload.wikimedia.org/wikipedia/commons/8/81/Jürgen_Klopp%2C_Liverpool_vs._Chelsea%2C_UEFA_Super_Cup_2019-08-14_04.jpg'
# )

# puts "----------------------------------------------------------------"
# puts "#{User.count} Users created"
# puts "----------------------------------------------------------------"

# puts "----------------------------------------------------------------"
# puts "Creating players..."
# puts "----------------------------------------------------------------"

# puts "----------------------------------------------------------------"
# puts "Creating players of liverpool"
# puts "----------------------------------------------------------------"

# position_mapping = {
#   "Centre-Forward" => "Attaquant",
#   "Goalkeeper" => "Gardien",
#   "Centre-Back" => "Défenseur",
#   "Left Winger" => "Attaquant",
#   "Second Striker" => "Attaquant",
#   "Right-Back" => "Défenseur",
#   "Defensive Midfield" => "Milieu",
#   "Central Midfield" => "Milieu",
#   "Attacking Midfield" => "Milieu",
#   "Right Winger" => "Attaquant",
#   "Left-Back" => "Défenseur",
#   "Right Midfield" => "Milieu",
#   "Left Midfield" => "Milieu"
# }

# url_liverpool = 'https://transfermarkt-api.fly.dev/clubs/31/players'
# uri = URI(url_liverpool)
# response = Net::HTTP.get(uri)
# data = JSON.parse(response)
# players = data['players']

# players.each do |player|
#   if player['marketValue'].present?
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Liverpool',
#       market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
#       price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
#       photo: ''
#     )
#   else
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Liverpool',
#       market_value: 0,
#       price_per_day: 0,
#       owner_id: julien[:id],
#       photo: ''
#     )
#   end
# end

# puts "----------------------------------------------------------------"
# puts "Creating players of lisboa"
# puts "----------------------------------------------------------------"

# url_lisboa = 'https://transfermarkt-api.fly.dev/clubs/294/players'
# uri = URI(url_lisboa)
# response = Net::HTTP.get(uri)
# data = JSON.parse(response)
# players = data['players']

# players.each do |player|
#   if player['marketValue'].present?
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Benfica Lisbonne',
#       market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
#       price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
#       photo: ''
#     )
#   else
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Benfica Lisbonne',
#       market_value: 0,
#       price_per_day: 0,
#       photo: ''
#     )
#   end
# end

# puts "----------------------------------------------------------------"
# puts "Creating players of juventus"
# puts "----------------------------------------------------------------"

# url_juventus = 'https://transfermarkt-api.fly.dev/clubs/506/players'
# uri = URI(url_juventus)
# response = Net::HTTP.get(uri)
# data = JSON.parse(response)
# players = data['players']

# players.each do |player|
#   if player['marketValue'].present?
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Juventus',
#       market_value: player['marketValue'].delete('^.0-9').to_i * 1000000,
#       price_per_day: player['marketValue'].delete('^.0-9').to_i * 1000000 / 365000,
#       photo: ''
#     )
#   else
#     Player.create(
#       id: player['id'],
#       name: player['name'],
#       position: position_mapping[player['position']],
#       age: player['age'],
#       nationality: JSON.parse(player['nationality'].to_s).join(', '),
#       height: player['height'],
#       foot: player['foot'] == 'right' ? 'droit' : 'gauche',
#       club: 'Juventus',
#       market_value: 0,
#       price_per_day: 0,
#       photo: ''
#     )
#   end
# end

# players_created = Player.all
# players_created.each do |player|
#   puts "Adding photo to #{player.name}"
#   top_url = "https://www.transfermarkt.com/-/profil/spieler/#{player.id}"
#   doc = Nokogiri::HTML.parse(URI.parse(top_url).open("User-Agent" => USER_AGENT).read)
#   photos = doc.search(".data-header__profile-image")
#   photo_url = photos.attribute("src").value
#   player.update(img: photo_url)
#   puts "Photo added to #{player.name}"
# end

# puts "----------------------------------------------------------------"
# puts "#{Player.count} players creeated"
# puts "----------------------------------------------------------------"

# puts "Seed done"
#

require 'net/http'
require 'json'
require 'open-uri'
require 'nokogiri'

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

POSITION_MAPPING = {
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

puts "----------------------------------------------------------------"
puts "Début de l'éxécution de la seed"
puts "----------------------------------------------------------------"

def create_or_update_user(email, first_name, last_name, password, avatar)
  user = User.find_or_initialize_by(email: email)
  user.assign_attributes(
    first_name: first_name,
    last_name: last_name,
    password: password,
    avatar: avatar
  )

  if user.save
    puts "Utilisateur créé ou mis à jour: #{user.first_name} #{user.last_name} (#{user.email})"
  else
    puts "Erreur concernant #{email}: #{user.errors.full_messages.join(', ')}"
  end
end

puts "----------------------------------------------------------------"
puts "Création des utilisateurs..."
puts "----------------------------------------------------------------"

create_or_update_user(
  'liverpool.liver@gmail.com',
  'Julien',
  'Marchand',
  'azerty1234',
  'https://upload.wikimedia.org/wikipedia/commons/8/81/Jürgen_Klopp%2C_Liverpool_vs._Chelsea%2C_UEFA_Super_Cup_2019-08-14_04.jpg'
)

puts "----------------------------------------------------------------"
puts "#{User.count} utilisateurs traités"
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Création des clubs..."
puts "----------------------------------------------------------------"

def create_or_update_club(name, country)
  club = Club.find_or_initialize_by(name: name)
  club.assign_attributes(
    name: name,
    country: country
  )

  if club.save
    puts "Club créé ou mis à jour: #{club.name}"
  else
    puts "Erreur concernant #{club.name}: #{club.errors.full_messages.join(', ')}"
  end
end

create_or_update_club('Liverpool', 'Angleterre')
create_or_update_club('Barcelone', 'Espagne')
create_or_update_club('Real Madrid', 'Espagne')
create_or_update_club('Juventus de Turin', 'Italie')
create_or_update_club('Benfica Lisbonne', 'Portugal')

def fetch_players_from_api(url, club_name)
  uri = URI(url)
  response = Net::HTTP.get(uri)
  data = JSON.parse(response)

  data['players'].each do |player_data|
    next if player_data['id'].nil?

    raw_value = player_data['marketValue']
    market_value = if raw_value.is_a?(String)
                     raw_value.delete('^.0-9').to_i * 1_000_000
                   else
                     0
                   end
    price_per_day = market_value.positive? ? market_value / 365_000 : 0

    player = Player.find_or_initialize_by(id: player_data['id'])
    player.assign_attributes(
      name: player_data['name'],
      position: POSITION_MAPPING[player_data['position']],
      age: player_data['age'],
      nationality: JSON.parse(player_data['nationality'].to_s).join(', '),
      height: player_data['height'],
      foot: player_data['foot'] == 'right' ? 'Droit' : 'Gauche',
      club: club_name,
      market_value: market_value,
      price_per_day: price_per_day
    )

    if player.save
      puts "Joueur créé ou modifié: #{player.name} (#{player.club})"
    else
      puts "Erreur concernant #{player_data['name']}: #{player.errors.full_messages.join(', ')}"
    end
  end
end

def update_player_photos
  players = Player.all
  players.each do |player|
    puts "Recherche de la photo de #{player.name}..."

    top_url = "https://www.transfermarkt.com/-/profil/spieler/#{player.id}"
    doc = Nokogiri::HTML.parse(URI.parse(top_url).open("User-Agent" => USER_AGENT).read)
    photo_element = doc.at_css(".data-header__profile-image")
    photo_url = photo_element.attribute("src").value
    if photo_url.nil?
      puts "Pas de photo pour #{player.name}. Skipping."
      next
    end
    if player.img.nil? || player.img != photo_url
      player.update(img: photo_url)
      puts "Photo mise à jour pour #{player.name}."
    else
      puts "Photo inchangée pour #{player.name}."
    end
  end
end

def associate_players_to_clubs
  clubs = Club.all
  clubs.each do |club|
    Player.where(club: club.name).update_all(club_id: club.id)
    puts "Players associated with #{club.name}"
  end
end

# Récupération des joueurs de Liverpool
puts "Fetching players for Liverpool..."
fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/31/players', 'Liverpool')

puts "Fetching players for Barcelone..."
fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/131/players', 'Barcelone')

puts "Fetching players for Liverpool..."
fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/506/players', 'Juventus de Turin')

# Mettre à jour les photos
puts "Updating photos for players..."
update_player_photos

associate_players_to_clubs

puts "----------------------------------------------------------------"
puts "#{Player.count} players processed"
puts "----------------------------------------------------------------"
puts "Seed process completed"
