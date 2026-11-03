require "test_helper"

# players(:one) : Player One, attaquant, France, club one, 100 000 €, 1 000 €/jour
# players(:two) : Player Two, défenseur, Spain, club two, 200 000 €, 2 000 €/jour
class PlayerTest < ActiveSupport::TestCase
  # --- Prix par jour ----------------------------------------------------------

  test "le prix par jour doit être un entier strictement positif" do
    player = players(:one)

    [ 0, -10, 12.5, nil ].each do |price|
      player.price_per_day = price
      assert_not player.valid?, "#{price.inspect} ne devrait pas être accepté"
    end

    player.price_per_day = 350
    assert player.valid?
  end

  test "le prix par jour se déduit de la valeur marchande (un an de location = sa valeur)" do
    assert_equal 547, Player.price_per_day_for(200_000_000)
  end

  test "un joueur de faible valeur coûte au moins 1 € par jour (jamais gratuit)" do
    # 200 000 / 365 000 donne 0 en division entière : le joueur aurait été loué gratuitement.
    assert_equal 1, Player.price_per_day_for(200_000)
  end

  # --- Recherche -------------------------------------------------------------

  test "une recherche vide renvoie tous les joueurs" do
    assert_equal Player.count, Player.search("").count
    assert_equal Player.count, Player.search(nil).count
  end

  test "la recherche porte sur le nom, sans tenir compte de la casse" do
    assert_equal [ players(:two) ], Player.search("player TWO").to_a
  end

  test "la recherche porte aussi sur le club et la nationalité" do
    assert_equal [ players(:one) ], Player.search("club one").to_a
    assert_equal [ players(:two) ], Player.search("spain").to_a
  end

  test "les caractères spéciaux de LIKE sont cherchés tels quels" do
    # Sans échappement, « % » voudrait dire « n'importe quoi » et renverrait tout le monde.
    assert_empty Player.search("%")
  end

  # --- Indisponibilités à venir ----------------------------------------------

  test "les indisponibilités sont les locations acceptées non terminées, dans l'ordre" do
    later = Booking.create!(player: players(:one), club: clubs(:two), total_price: 1, status: :accepted,
                            start_date: Date.current + 30, end_date: Date.current + 40)
    current = Booking.create!(player: players(:one), club: clubs(:three), total_price: 1, status: :accepted,
                              start_date: Date.current - 2, end_date: Date.current + 3)
    Booking.create!(player: players(:one), club: clubs(:two), total_price: 1, status: :accepted,
                    start_date: Date.current - 20, end_date: Date.current - 10) # terminée
    # bookings(:one) est en attente : pas une indisponibilité

    assert_equal [ current, later ], players(:one).upcoming_unavailabilities.to_a
  end

  # --- Tri -------------------------------------------------------------------

  test "par défaut, les joueurs sont triés par valeur décroissante" do
    assert_equal [ players(:two), players(:one) ], Player.sorted_by(nil).to_a
  end

  test "tri par prix par jour croissant" do
    assert_equal [ players(:one), players(:two) ], Player.sorted_by("price").to_a
  end

  test "une clé de tri inconnue retombe sur le tri par défaut" do
    # Jamais de paramètre utilisateur injecté dans un ORDER BY : on choisit dans une liste fermée.
    assert_equal [ players(:two), players(:one) ], Player.sorted_by("name; DROP TABLE players").to_a
  end
end
