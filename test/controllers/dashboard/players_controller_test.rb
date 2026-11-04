require "test_helper"

class Dashboard::PlayersControllerTest < ActionDispatch::IntegrationTest
  # users(:one) est du club one, propriétaire de players(:one).
  # players(:two) appartient au club two.

  # Prêt accepté et en cours aujourd'hui : `borrower` emprunte `player`.
  def create_active_loan(player:, borrower:)
    Booking.create!(
      player: player,
      club: borrower,
      start_date: Date.current - 1,
      end_date: Date.current + 1,
      total_price: 1000,
      status: :accepted
    )
  end

  test "un visiteur non connecté est redirigé vers la connexion" do
    get dashboard_players_url

    assert_redirected_to new_user_session_url
  end

  test "l'effectif affiche les joueurs du club et les joueurs empruntés" do
    create_active_loan(player: players(:two), borrower: clubs(:one))
    sign_in users(:one)

    get dashboard_players_url

    assert_response :success
    assert_select ".player-card__name", text: players(:one).name
    assert_select ".player-card__name", text: players(:two).name
  end

  test "l'effectif n'affiche pas les joueurs prêtés à un autre club" do
    create_active_loan(player: players(:one), borrower: clubs(:two))
    sign_in users(:one)

    get dashboard_players_url

    assert_response :success
    assert_select ".player-card__name", text: players(:one).name, count: 0
  end

  test "les onglets indiquent la page en cours et les effectifs de chaque vue" do
    create_active_loan(player: players(:two), borrower: clubs(:one))
    sign_in users(:one)

    get loaned_in_dashboard_players_url

    assert_select ".segmented__item[aria-current=page][href=?]", loaned_in_dashboard_players_path
    assert_select ".segmented__item[href=?] .segmented__count", loaned_in_dashboard_players_path, text: "1"
  end

  test "la page Empruntés montre chaque prêt : joueur, club prêteur, jours restants" do
    create_active_loan(player: players(:two), borrower: clubs(:one))
    sign_in users(:one)

    get loaned_in_dashboard_players_url

    assert_select ".loan-card", count: 1
    assert_select ".loan-card", text: /#{players(:two).name}/
    assert_select ".loan-card", text: /Emprunté à #{clubs(:two).name}/
    assert_select ".loan-card .badge", text: "J-1"
  end

  test "la page Prêtés montre nos joueurs partis chez un autre club" do
    create_active_loan(player: players(:one), borrower: clubs(:two))
    sign_in users(:one)

    get loaned_out_dashboard_players_url

    assert_select ".loan-card", text: /Prêté à #{clubs(:two).name}/
  end

  test "un état vide s'affiche quand aucun joueur n'est prêté" do
    sign_in users(:one)

    get loaned_out_dashboard_players_url

    assert_select ".loan-card", count: 0
    assert_select ".empty-state"
  end
end
