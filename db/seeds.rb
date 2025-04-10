puts "----------------------------------------------------------------"
puts "Début de la mise à jour de la base de données."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Traitement des utilisateurs..."
puts "----------------------------------------------------------------"

UserService.create_or_update_user(
  'liverpool.liver@gmail.com',
  'Julien',
  'Marchand',
  'azerty1234',
  'https://upload.wikimedia.org/wikipedia/commons/8/81/Jürgen_Klopp%2C_Liverpool_vs._Chelsea%2C_UEFA_Super_Cup_2019-08-14_04.jpg'
)

puts "----------------------------------------------------------------"
puts "#{User.count} utilisateurs traités."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Traitement des clubs..."
puts "----------------------------------------------------------------"

liverpool = ClubService.create_or_update_club('Liverpool FC', 'Angleterre', 'Anfield', 'Liv.png')
barcelone = ClubService.create_or_update_club('FC Barcelone', 'Espagne', 'Camp Nou', 'Barca.png')
madrid = ClubService.create_or_update_club('Real Madrid', 'Espagne', 'Santiago Bernabeu', 'RM.png')
juventus = ClubService.create_or_update_club('Juventus', 'Italie', 'Juventus Stadium', 'Juv.png')
benfica = ClubService.create_or_update_club('Benfica Lisbonne', 'Portugal', 'Estadio do Benfica', 'BL.png')
paris = ClubService.create_or_update_club('Paris Saint-Germain', 'France', 'Parc des Princes', 'Paris.png')
munich = ClubService.create_or_update_club('Bayern Munich', 'Allemagne', 'Allianz Arena', 'Bay.png')
arsenal = ClubService.create_or_update_club('Arsenal', 'Angleterre', 'Emirates Stadium', 'Ars.png')

puts "#{Club.count}"

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

puts "Récupération des données des joueurs de Benfica..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/583/players', paris)

puts "Récupération des données des joueurs de Benfica..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/27/players', munich)

puts "Récupération des données des joueurs de Benfica..."
PlayerService.fetch_players_from_api('https://transfermarkt-api.fly.dev/clubs/11/players', arsenal)

puts "----------------------------------------------------------------"
puts "Traitement des photos des joueurs..."
puts "----------------------------------------------------------------"
PlayerService.update_player_photos

puts "----------------------------------------------------------------"
puts "#{Player.count} joueurs traités."
puts "----------------------------------------------------------------"

puts "Base de données mise à jour avec succès."
