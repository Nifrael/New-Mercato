require "test_helper"

# Le shell de l'application : une seule navigation, affichée en barre d'onglets
# (mobile) ou en sidebar (desktop) selon la largeur — c'est le CSS qui décide.
class NavigationTest < ActionDispatch::IntegrationTest
  # --- Visiteur --------------------------------------------------------------

  test "un visiteur voit les pages publiques et le lien de connexion" do
    get players_url

    assert_select ".app-nav__link[href=?]", players_path
    assert_select ".app-nav__link[href=?]", clubs_path
    assert_select ".app-nav__link[href=?]", new_user_session_path
    assert_select ".app-nav__link[href=?]", dashboard_path, count: 0
  end

  test "le lien de la page en cours est marqué comme actif" do
    get players_url

    assert_select ".app-nav__link[aria-current=page][href=?]", players_path
    assert_select ".app-nav__link[aria-current=page]", count: 1
  end

  # --- Utilisateur connecté --------------------------------------------------

  test "un utilisateur connecté voit son espace club et peut se déconnecter" do
    sign_in users(:one)

    get players_url

    assert_select ".app-nav__link[href=?]", dashboard_path
    assert_select ".app-nav__link[href=?]", dashboard_bookings_path
    assert_select ".app-nav__link[href=?]", dashboard_players_path
    assert_select ".app-nav__link[href=?]", new_user_session_path, count: 0
    assert_select "form[action=?] button", destroy_user_session_path
  end

  test "la pastille des demandes affiche le nombre de demandes reçues en attente" do
    # bookings(:one) : le club two demande players(:one), qui appartient au club de users(:one).
    sign_in users(:one)

    get players_url

    assert_select ".app-nav__link[href=?] .app-nav__badge", dashboard_bookings_path, text: "1"
  end

  test "pas de pastille quand aucune demande n'attend" do
    bookings(:one).update!(status: :refused)
    sign_in users(:one)

    get players_url

    assert_select ".app-nav__badge", count: 0
  end

  # --- Page de bienvenue -----------------------------------------------------

  test "la page de bienvenue s'affiche en plein écran, sans navigation" do
    get root_url

    assert_select ".app-nav", count: 0
  end
end
