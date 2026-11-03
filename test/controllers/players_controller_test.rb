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

    assert_select ".catalog__count", text: "1 joueur"

    get players_url
    assert_select ".catalog__count", text: "2 joueurs" # pluriel français (pas « 2 joueur »)
  end

  test "un état vide s'affiche quand aucun joueur ne correspond" do
    get players_url(q: "personne ne s'appelle comme ça")

    assert_select ".player-card", count: 0
    assert_select "turbo-frame#players .empty-state"
  end

  # --- Fiche joueur : le panneau de réservation dépend de qui regarde ---------

  test "un visiteur voit la fiche et est invité à se connecter pour louer" do
    get player_url(players(:one))

    assert_response :success
    assert_select "h1", text: players(:one).name
    assert_select ".stat__label", text: "Prix / jour"
    assert_select ".booking-panel a[href=?]", new_user_session_path
    assert_select ".booking-panel form", count: 0
  end

  test "un membre d'un autre club voit le formulaire de réservation avec champs date natifs" do
    sign_in users(:two)

    get player_url(players(:one))

    assert_select ".booking-panel form[action=?]", player_bookings_path(players(:one)) do
      assert_select "input[type=date][name=?][required]", "booking[start_date]"
      assert_select "input[type=date][name=?][required]", "booking[end_date]"
    end
    # Total calculé en direct (Stimulus) à partir du prix par jour.
    assert_select "form[data-controller=booking-total][data-booking-total-price-value=?]",
                  players(:one).price_per_day.to_s
  end

  test "un membre du club propriétaire ne peut pas réserver son propre joueur" do
    sign_in users(:one)

    get player_url(players(:one))

    assert_select ".booking-panel form", count: 0
    assert_select ".booking-panel", text: /joueur de votre club/
  end

  test "les périodes déjà louées sont affichées" do
    Booking.create!(player: players(:one), club: clubs(:three), total_price: 1, status: :accepted,
                    start_date: Date.current + 30, end_date: Date.current + 40)

    get player_url(players(:one))

    assert_select ".availability__item", text: /#{I18n.l(Date.current + 30, format: :compact)}/
  end

  test "sans location à venir, le joueur est annoncé disponible" do
    get player_url(players(:one))

    assert_select ".availability", text: /Disponible/
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
