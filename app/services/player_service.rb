require "net/http"
require "json"
require "open-uri"
require "nokogiri"

USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

class PlayerService
  POSITION_MAPPING = {
  "Centre-Forward" => 3,
  "Goalkeeper" => 0,
  "Centre-Back" => 1,
  "Left Winger" => 3,
  "Second Striker" => 3,
  "Right-Back" => 1,
  "Defensive Midfield" => 2,
  "Central Midfield" => 2,
  "Attacking Midfield" => 2,
  "Right Winger" => 3,
  "Left-Back" => 1,
  "Right Midfield" => 2,
  "Left Midfield" => 2,
  nil => 4
  }

  def self.fetch_players_from_api(url, club)
    uri = URI(url)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    data["players"].each do |player_data|
      raw_value = player_data["marketValue"]
        if raw_value.is_a?(String)
          market_value = raw_value.delete("^.0-9").to_i * 1_000_000
        elsif !raw_value.nil?
          market_value = raw_value
        else
          market_value = 10_000_000
        end
      price_per_day = market_value / 365_000

      player = Player.find_or_initialize_by(id: player_data["id"])
      player.assign_attributes(
        name: player_data["name"],
        position: POSITION_MAPPING[player_data["position"]],
        age: player_data["age"],
        nationality: JSON.parse(player_data["nationality"].to_s).join(", "),
        height: player_data["height"],
        foot: player_data["foot"] == "right" ? "Droit" : "Gauche",
        market_value: market_value,
        price_per_day: price_per_day
      )
      player.club = club

      if player.save
        if player.saved_change_to_id?
          puts "Joueur créé : #{player.name} (#{player.club.name})."
        else
          puts "Joueur mis à jour : #{player.name} (#{player.club.name})."
        end
      else
        puts "Erreur concernant #{player_data['name']}: #{player.errors.full_messages.join(', ')}"
      end
    end
  end

  def self.update_player_photos
    players = Player.all
    players.each do |player|
      puts "Recherche de la photo de #{player.name}..."

      top_url = "https://www.transfermarkt.com/-/profil/spieler/#{player.id}"
      doc = Nokogiri::HTML.parse(URI.parse(top_url).open("User-Agent" => USER_AGENT).read)
      photo_element = doc.at_css(".data-header__profile-image")
      photo_url = photo_element.attribute("src").value
      if player.photo.nil? || player.photo != photo_url
        player.update(photo: photo_url)
        puts "Photo mise à jour pour #{player.name}."
      else
        puts "Photo inchangée pour #{player.name}."
      end
    end
  end
end
