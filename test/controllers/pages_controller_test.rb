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

  test "chaque club participant mène à sa page" do
    get accueil_url

    Club.find_each do |club|
      assert_select ".landing__clubs a[href=?]", club_path(club)
    end
  end
end
