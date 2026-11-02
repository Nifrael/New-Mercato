require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  # --- Pages publiques -------------------------------------------------------

  test "un visiteur peut voir la liste des joueurs" do
    get players_url

    assert_response :success
    assert_select ".player-card__name", text: players(:one).name
  end

  # --- Catalogue : formulaire GET qui cible une Turbo Frame -------------------

  test "les résultats sont dans une Turbo Frame que le formulaire de filtres cible" do
    get players_url

    assert_select "form[method=get][action=?][data-turbo-frame=players]", players_path
    assert_select "turbo-frame#players[data-turbo-action=advance] .player-card", count: Player.count
    # Les cartes (liens vers la fiche) doivent naviguer la PAGE, pas seulement la frame.
    assert_select "turbo-frame#players[target=_top]"
  end

  test "filtrer par poste ne garde que les joueurs de ce poste" do
    get players_url(position: "attaquant")

    assert_select ".player-card__name", text: players(:one).name
    assert_select ".player-card__name", text: players(:two).name, count: 0
    assert_select "input[name=position][value=attaquant][checked]" # le filtre actif reste coché
  end

  test "la recherche filtre par nom, club ou nationalité et reste dans le champ" do
    get players_url(q: "spain")

    assert_select ".player-card__name", text: players(:two).name
    assert_select ".player-card__name", text: players(:one).name, count: 0
    assert_select "input[name=q][value=spain]"
  end

  test "le nombre de résultats est affiché" do
    get players_url(position: "attaquant")

    assert_select ".catalog__count", text: /1 joueur/
  end

  test "un état vide s'affiche quand aucun joueur ne correspond" do
    get players_url(q: "personne ne s'appelle comme ça")

    assert_select ".player-card", count: 0
    assert_select "turbo-frame#players .empty-state"
  end

  test "un visiteur peut voir la fiche d'un joueur" do
    get player_url(players(:one))

    assert_response :success
  end

  # --- Modification : réservée au club du joueur -----------------------------
  # Les vues edit/update sont encore des placeholders (phase 6) : on ne teste
  # ici que la partie stable, c'est-à-dire QUI a le droit d'y accéder.

  test "un visiteur non connecté est redirigé vers la connexion" do
    get edit_player_url(players(:one))

    assert_redirected_to new_user_session_url
  end

  test "un utilisateur d'un autre club ne peut pas modifier le joueur" do
    sign_in users(:two) # club two, alors que players(:one) appartient au club one

    get edit_player_url(players(:one))

    assert_response :redirect
    assert_equal "Vous n'êtes pas autorisé à effectuer cette action ou accéder à cette section.", flash[:alert]
  end

  test "un utilisateur du club du joueur peut accéder à la modification" do
    sign_in users(:one)

    get edit_player_url(players(:one))

    assert_response :success
  end
end
