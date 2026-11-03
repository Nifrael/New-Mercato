require "test_helper"

# La navigation dépend de QUI visite, pas de la page (cf. NavigationHelper#app_shell?) :
# - visiteur → .app-nav--site : barre d'onglets (mobile), barre en haut (desktop) ;
# - connecté → .app-nav--sidebar : barre d'onglets (mobile) ou sidebar
#   (desktop) selon la largeur, c'est le CSS qui décide ;
# - exception : la vitrine /accueil garde la barre du site, même connecté.
class NavigationTest < ActionDispatch::IntegrationTest
  # --- Visiteur --------------------------------------------------------------

  test "un visiteur a la barre du site, pas la sidebar" do
    get players_url

    assert_select ".app-nav--site", count: 1
    assert_select ".app-nav--sidebar", count: 0
  end

  test "un visiteur voit les pages publiques et le lien de connexion" do
    get players_url

    assert_select ".app-nav--site a[href=?]", players_path
    assert_select ".app-nav--site a[href=?]", clubs_path
    assert_select ".app-nav--site a[href=?]", new_user_session_path
    assert_select ".app-nav--site a[href=?]", dashboard_path, count: 0
  end

  test "le lien de la page en cours est marqué comme actif" do
    get players_url

    assert_select ".app-nav--site .app-nav__link[aria-current=page][href=?]", players_path
    assert_select ".app-nav--site .app-nav__link[aria-current=page]", count: 1
  end

  test "la page de connexion garde la barre du site" do
    get new_user_session_url

    assert_select ".app-nav--site", count: 1
  end

  # --- Utilisateur connecté --------------------------------------------------

  test "connecté, la sidebar remplace la barre du site, même sur les pages publiques" do
    sign_in users(:one)

    get players_url

    assert_select ".app-nav--sidebar", count: 1
    assert_select ".app-nav--site", count: 0
  end

  test "connecté, la vitrine /accueil garde la barre du site, avec un lien vers son espace" do
    sign_in users(:one)

    get accueil_url

    assert_select ".app-nav--site a[href=?]", dashboard_path
    assert_select ".app-nav--site a[href=?]", new_user_session_path, count: 0
    assert_select ".app-nav--sidebar", count: 0
  end

  test "le lien du tableau de bord n'est actif que sur le tableau de bord lui-même" do
    sign_in users(:one)

    get dashboard_bookings_url

    assert_select ".app-nav__link[aria-current=page][href=?]", dashboard_bookings_path
    assert_select ".app-nav__link[aria-current=page]", count: 1 # pas aussi sur « Tableau de bord »
  end

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

  # --- Footer (pages visiteurs uniquement) -----------------------------------

  test "un visiteur a le footer, avec les mentions légales et le code source" do
    get players_url

    assert_select "footer.site-footer a[href=?]", mentions_legales_path
    assert_select "footer.site-footer a[href=?]", "https://github.com/Nifrael/New-Mercato"
  end

  test "connecté, l'espace club n'a pas de footer" do
    sign_in users(:one)

    get players_url

    assert_select "footer.site-footer", count: 0
  end

  test "connecté, la vitrine /accueil garde le footer" do
    sign_in users(:one)

    get accueil_url

    assert_select "footer.site-footer", count: 1
  end

  # --- Page de bienvenue -----------------------------------------------------

  test "la page de bienvenue s'affiche en plein écran, sans navigation" do
    get root_url

    assert_select ".app-nav", count: 0
    assert_select "footer.site-footer", count: 0
  end
end
