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
    assert_select ".row-players__name", text: players(:one).name
    assert_select ".row-players__name", text: players(:two).name
  end

  test "l'effectif n'affiche pas les joueurs prêtés à un autre club" do
    create_active_loan(player: players(:one), borrower: clubs(:two))
    sign_in users(:one)

    get dashboard_players_url

    assert_response :success
    assert_select ".row-players__name", text: players(:one).name, count: 0
  end
end
