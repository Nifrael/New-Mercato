puts "----------------------------------------------------------------"
puts "Début de la mise à jour de la base de données."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Traitement des clubs..."
puts "----------------------------------------------------------------"

liverpool = ClubService.create_or_update_club('Liverpool FC', 'Angleterre', 'Premier League', 300_000_000, 'Anfield', 'Logos/Liv.png')

barcelone = ClubService.create_or_update_club('FC Barcelone', 'Espagne', 'Liga', 200_000_000, 'Camp Nou', 'Logos/BARCA.png')

madrid = ClubService.create_or_update_club('Real Madrid', 'Espagne', 'Liga', 400_000_000, 'Santiago Bernabeu', 'Logos/RM.png')

juventus = ClubService.create_or_update_club('Juventus', 'Italie', 'Serie A', 100_000_000, 'Juventus Stadium', 'Logos/Juv.png')

benfica = ClubService.create_or_update_club('Benfica Lisbonne', 'Portugal', 'Liga Portugal', 50_000_000, 'Estadio do Benfica', 'Logos/BL.png')

paris = ClubService.create_or_update_club('Paris Saint-Germain', 'France', 'Ligue 1', 500_000_000, 'Parc des Princes', 'Logos/Paris.png')

bayern = ClubService.create_or_update_club('Bayern Munich', 'Allemagne', 'Bundesliga', 300_000_000, 'Allianz Arena', 'Logos/Bay.png')

arsenal = ClubService.create_or_update_club('Arsenal', 'Angleterre', 'Premier League', 250_000_000, 'Emirates Stadium', 'Logos/Ars.png')

puts "#{Club.count} créés."

puts "----------------------------------------------------------------"
puts "Traitement des utilisateurs..."
puts "----------------------------------------------------------------"

UserService.create_or_update_user('liverpool@gmail.com', 'John', 'Henry', 'liverpool', 'Avatar.png', 1, liverpool.id)

UserService.create_or_update_user('barcelone@gmail.com', 'Joan', 'Laporta', 'barcelone', 'Avatar.png', 1, barcelone.id)

UserService.create_or_update_user('madrid@gmail.com', 'Florentino', 'Perez', 'madrid', 'Avatar.png', 1, madrid.id)

UserService.create_or_update_user('juventus@gmail.com', 'Gianluca', 'Ferrero', 'juventus', 'Avatar.png', 1, juventus.id)

UserService.create_or_update_user('benfica@gmail.com', 'Rui', 'Costa', 'benfica', 'Avatar.png', 1, benfica.id)

UserService.create_or_update_user('paris@gmail.com', 'Nasser', 'Al-Khelaifi', 'parissg', 'Avatar.png', 1, paris.id)

UserService.create_or_update_user('bayern@gmail.com', 'Herbert', 'Hainer', 'bayern', 'Avatar.png', 1, bayern.id)

UserService.create_or_update_user('arsenal@gmail.com', 'Richard', 'Garlick', 'arsenal', 'Avatar.png', 1, arsenal.id)

puts "----------------------------------------------------------------"
puts "#{User.count} utilisateurs traités."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Traitement des joueurs..."
puts "----------------------------------------------------------------"

puts "Récupération des données des joueurs de Liverpool..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/31/players', liverpool)

puts "Récupération des données des joueurs de Barcelone..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/131/players', barcelone)

puts "Récupération des données des joueurs de Juventus..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/506/players', juventus)

puts "Récupération des données des joueurs de Madrid..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/418/players', madrid)

puts "Récupération des données des joueurs de Benfica..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/294/players', benfica)

puts "Récupération des données des joueurs de Paris..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/583/players', paris)

puts "Récupération des données des joueurs de Munich..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/27/players', bayern)

puts "Récupération des données des joueurs d'Arsenal..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/11/players', arsenal)

# puts "----------------------------------------------------------------"
# puts "Traitement des photos des joueurs..."
# puts "----------------------------------------------------------------"
# PlayerService.update_player_photos

puts "----------------------------------------------------------------"
puts "#{Player.count} joueurs traités."
puts "----------------------------------------------------------------"

puts "Base de données mise à jour avec succès."
