
class ClubService
  def self.create_or_update_club(name, country, stadium, photo)
    club = Club.find_or_initialize_by(name: name)
    club.assign_attributes(
      name: name,
      country: country,
      stadium: stadium,
      photo: photo
    )

    if club.save
      if club.saved_change_to_id?
        puts "Club créé : #{club.name}"
      else
        puts "Club mis à jour : #{club.name}"
      end
    else
      puts "Erreur concernant #{club.name}: #{club.errors.full_messages.join(', ')}"
    end
    return club
  end
end
