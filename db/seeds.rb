puts "----------------------------------------------------------------"
puts "Début de la mise à jour de la base de données."
puts "----------------------------------------------------------------"

puts "----------------------------------------------------------------"
puts "Traitement des clubs..."
puts "----------------------------------------------------------------"

liverpool = ClubService.create_or_update_club(
  'Liverpool FC',
  'Angleterre',
  'Premier League',
  300_000_000,
  'Anfield',
  '/Logos/Liv.png')
# barcelone = ClubService.create_or_update_club('FC Barcelone', 'Espagne', 'Camp Nou', 'Barca.png')
# madrid = ClubService.create_or_update_club('Real Madrid', 'Espagne', 'Santiago Bernabeu', 'RM.png')
# juventus = ClubService.create_or_update_club('Juventus', 'Italie', 'Juventus Stadium', 'Juv.png')
# benfica = ClubService.create_or_update_club('Benfica Lisbonne', 'Portugal', 'Estadio do Benfica', 'BL.png')
# paris = ClubService.create_or_update_club('Paris Saint-Germain', 'France', 'Parc des Princes', 'Paris.png')
# munich = ClubService.create_or_update_club('Bayern Munich', 'Allemagne', 'Allianz Arena', 'Bay.png')
# arsenal = ClubService.create_or_update_club('Arsenal', 'Angleterre', 'Emirates Stadium', 'Ars.png')

puts "#{Club.count} créés."

puts "----------------------------------------------------------------"
puts "Traitement des utilisateurs..."
puts "----------------------------------------------------------------"

UserService.create_or_update_user(
  'liverpool@gmail.com',
  'John',
  'Henry',
  'liverpool',
  'Avatar.png',
  1,
  liverpool.id
)

puts "----------------------------------------------------------------"
puts "#{User.count} utilisateurs traités."
puts "----------------------------------------------------------------"
