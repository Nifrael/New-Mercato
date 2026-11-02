require "test_helper"

class PlayersControllerTest < ActionDispatch::IntegrationTest
  # --- Pages publiques -------------------------------------------------------

  test "un visiteur peut voir la liste des joueurs" do
    get players_url

    assert_response :success
    assert_select ".player-card__name", text: players(:one).name
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
