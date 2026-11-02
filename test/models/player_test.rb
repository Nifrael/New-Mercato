require "test_helper"

# players(:one) : Player One, attaquant, France, club one, 100 000 €, 1 000 €/jour
# players(:two) : Player Two, défenseur, Spain, club two, 200 000 €, 2 000 €/jour
class PlayerTest < ActiveSupport::TestCase
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
