require "test_helper"

class ClubsControllerTest < ActionDispatch::IntegrationTest
  test "un visiteur peut voir la liste des clubs" do
    get clubs_url

    assert_response :success
    assert_select ".club-card__name", text: clubs(:one).name
    # Piège : sur une requête groupée (with_players_count), un COUNT renvoie un hash.
    assert_select ".page-header__lead", text: /\A3 clubs prêtent/
  end

  test "la liste présente le dirigeant de chaque club, pas un employé" do
    get clubs_url

    assert_select ".club-card__owner", text: /#{users(:one).first_name}/
    assert_select ".club-card__owner", text: /#{users(:employe_one).first_name}/, count: 0
  end

  test "un club sans dirigeant n'empêche pas d'afficher la liste" do
    users(:two).destroy! # le club two n'a plus aucun membre, donc pas de dirigeant

    get clubs_url

    assert_response :success
    assert_select ".club-card__name", text: clubs(:two).name
  end

  test "chaque carte mène à la page du club et affiche son nombre de joueurs" do
    get clubs_url

    assert_select "a.club-card[href=?]", club_path(clubs(:one)) do
      assert_select ".club-card__players", text: "1 joueur"
    end
    assert_select "a.club-card[href=?] .club-card__players", club_path(clubs(:three)), text: "0 joueur"
  end

  # --- Page d'un club --------------------------------------------------------

  test "la page d'un club présente le club, son dirigeant et ses chiffres" do
    get club_url(clubs(:one))

    assert_response :success
    assert_select "h1", text: clubs(:one).name
    assert_select ".club-hero", text: /#{clubs(:one).stadium}/
    assert_select ".club-hero", text: /#{users(:one).first_name} #{users(:one).last_name}/
    assert_select ".stat__value", text: "1 M€" # budget
    assert_select "a[href=?]", clubs_path # retour à la liste
  end

  test "la page d'un club liste ses joueurs, et seulement les siens" do
    get club_url(clubs(:one))

    assert_select ".player-card__name", text: players(:one).name
    assert_select ".player-card__name", text: players(:two).name, count: 0
  end

  test "un club sans joueur affiche un état vide" do
    get club_url(clubs(:three))

    assert_select ".player-card", count: 0
    assert_select ".empty-state"
  end

  test "un club inexistant renvoie une page 404" do
    get club_url(id: 0)

    assert_response :not_found
  end
end
