require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  include ActionView::Helpers::NumberHelper # number_to_currency, pour comparer le total affiché

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

  # --- La location racontée ---------------------------------------------------

  test "le fonctionnement est raconté sur une vraie carte de réservation, avec une ancre pour y aller" do
    get accueil_url

    assert_select "a[href='#comment-ca-marche']"
    assert_select "#comment-ca-marche .landing__story-step", count: 3
    # Le joueur le plus coté, demandé par un AUTRE club que le sien.
    assert_select "#comment-ca-marche .booking-card__player", text: players(:two).name
    assert_select "#comment-ca-marche .booking-card__counterpart", text: /#{players(:two).club.name}/
    assert_select "#comment-ca-marche .badge", text: "En attente"
    assert_select "#comment-ca-marche .badge", text: "Accepté"
  end

  test "le total de l'exemple vient du vrai calcul : 21 jours au prix du joueur" do
    get accueil_url

    total = 21 * players(:two).price_per_day
    assert_select "#comment-ca-marche .booking-card__total", text: /#{number_to_currency(total, precision: 0)}/
  end

  test "la location d'exemple n'est jamais enregistrée" do
    assert_no_difference("Booking.count") { get accueil_url }
  end

  test "sans joueur disponible, pas de récit ni d'ancre vers lui" do
    Player.update_all(status: Player.statuses[:unavailable])

    get accueil_url

    assert_select "#comment-ca-marche", count: 0
    assert_select "a[href='#comment-ca-marche']", count: 0
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

  # --- Les deux côtés d'une location -----------------------------------------

  test "l'accueil présente le côté emprunteur et le côté prêteur" do
    get accueil_url

    assert_select ".landing__sides h2", count: 1 # titre de section (lu par les lecteurs d'écran)
    assert_select ".landing__side h3", count: 2
    assert_select ".landing__side a[href=?]", players_path
    assert_select ".landing__side a[href=?]", new_user_session_path
  end

  test "connecté, le côté prêteur mène à son effectif au lieu de la connexion" do
    sign_in users(:one)

    get accueil_url

    assert_select ".landing__side a[href=?]", dashboard_players_path
    assert_select ".landing__side a[href=?]", new_user_session_path, count: 0
  end

  # --- Le marché en chiffres -------------------------------------------------

  test "les chiffres du marché sont calculés depuis la base" do
    get accueil_url

    average = number_to_currency(Player.average(:price_per_day), precision: 0)
    assert_select ".landing__market .stat", count: 4
    assert_select ".landing__market .stat--accent .stat__value", text: average
    assert_select ".landing__market .stat__value", text: Club.distinct.count(:league).to_s
    assert_select ".landing__market .stat__value", text: Player.distinct.count(:nationality).to_s
  end

  test "sans aucun joueur, pas de chiffres du marché" do
    Booking.delete_all
    Player.delete_all

    get accueil_url

    assert_select ".landing__market", count: 0
  end

  test "chaque club participant mène à sa page" do
    get accueil_url

    Club.find_each do |club|
      assert_select ".landing__clubs a[href=?]", club_path(club)
    end
  end
end
