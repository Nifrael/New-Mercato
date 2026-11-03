require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  # --- Page de bienvenue (racine du site) ------------------------------------

  test "la page de bienvenue s'affiche avec un seul titre principal" do
    get root_url

    assert_response :success
    assert_select "h1", count: 1 # un seul h1 par page : accessibilité et référencement
  end

  test "la page de bienvenue mène à l'accueil" do
    get root_url

    assert_select "a.hero__cta[href=?]", accueil_path
  end

  # --- Page de présentation (/accueil) ---------------------------------------
  # Tout ce que la page affiche vient de l'appli réelle : chiffres en base, vraies étapes.

  test "l'accueil présente l'accroche et mène au catalogue et à la connexion" do
    get accueil_url

    assert_response :success
    assert_select "h1", text: /Louez-les/
    assert_select ".landing__actions a[href=?]", players_path
    assert_select ".landing__actions a[href=?]", new_user_session_path
  end

  test "connecté, l'accueil propose le tableau de bord au lieu de la connexion" do
    sign_in users(:one)

    get accueil_url

    assert_select ".landing__actions a[href=?]", dashboard_path
    assert_select ".landing__actions a[href=?]", new_user_session_path, count: 0
  end

  test "les chiffres affichés viennent de la base" do
    get accueil_url

    assert_select ".landing__figures", text: /#{Player.count} joueurs/
    assert_select ".landing__figures", text: /#{Club.count} clubs/
  end

  test "les trois étapes expliquent le fonctionnement, avec une ancre pour y aller" do
    get accueil_url

    assert_select "a[href='#comment-ca-marche']"
    assert_select "#comment-ca-marche .steps__item", count: 3
  end

  # --- Vitrine des joueurs ----------------------------------------------------

  test "la vitrine montre les joueurs disponibles, chacun menant à sa fiche" do
    get accueil_url

    assert_select ".landing__players .player-card", count: 2
    assert_select ".landing__players a[href=?]", player_path(players(:one))
    assert_select ".landing__players h3.player-card__name", text: players(:one).name
  end

  test "la vitrine n'affiche ni les joueurs loués ni les indisponibles" do
    players(:one).rented!
    players(:two).unavailable!

    get accueil_url

    assert_select ".landing__players", count: 0 # aucun disponible : la section disparaît
  end

  test "la vitrine se limite aux 4 joueurs disponibles les plus cotés" do
    3.times do |i|
      players(:one).dup.update!(name: "Recrue #{i}", market_value: 1_000_000 + i)
    end

    get accueil_url

    assert_select ".landing__players .player-card", count: 4
    assert_select ".landing__players .player-card__name", text: players(:one).name, count: 0 # le moins coté sort
  end

  test "chaque club participant mène à sa page" do
    get accueil_url

    Club.find_each do |club|
      assert_select ".landing__clubs a[href=?]", club_path(club)
    end
  end
end
