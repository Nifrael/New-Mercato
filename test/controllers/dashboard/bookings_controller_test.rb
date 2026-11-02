require "test_helper"

# bookings(:one) : le club two (users(:two)) demande à louer players(:one),
# qui appartient au club one (users(:one)). Statut : pending.
#   - users(:one)   → propriétaire du joueur : peut voir, accepter, refuser
#   - users(:two)   → emprunteur : peut voir, ne peut pas décider
#   - users(:three) → club étranger à la réservation : aucun accès
class Dashboard::BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @booking = bookings(:one)
  end

  # --- Liste -----------------------------------------------------------------

  test "un visiteur non connecté est redirigé vers la connexion" do
    get dashboard_bookings_url

    assert_redirected_to new_user_session_url
  end

  test "un utilisateur connecté voit ses demandes" do
    sign_in users(:one)

    get dashboard_bookings_url

    assert_response :success
  end

  # --- Détail ----------------------------------------------------------------

  test "le propriétaire et l'emprunteur peuvent voir la réservation" do
    [ users(:one), users(:two) ].each do |user|
      sign_in user

      get dashboard_booking_url(@booking)

      assert_response :success
    end
  end

  test "un club étranger à la réservation ne peut pas la voir" do
    sign_in users(:three)

    get dashboard_booking_url(@booking)

    assert_response :redirect
    assert flash[:alert].present?
  end

  test "une réservation inexistante renvoie une page 404" do
    sign_in users(:one)

    get dashboard_booking_url(id: 0)

    assert_response :not_found
  end

  # --- Acceptation -----------------------------------------------------------

  test "le propriétaire du joueur peut accepter la demande" do
    sign_in users(:one)

    patch accept_dashboard_booking_url(@booking)

    assert_predicate @booking.reload, :accepted?
    assert_predicate @booking.player.reload, :rented?
    assert_redirected_to dashboard_bookings_url
    assert flash[:notice].present?
  end

  test "l'emprunteur et un club étranger ne peuvent pas accepter la demande" do
    [ users(:two), users(:three) ].each do |user|
      sign_in user

      patch accept_dashboard_booking_url(@booking)

      assert_response :redirect
      assert flash[:alert].present?
      assert_predicate @booking.reload, :pending?
    end
  end

  test "une demande déjà refusée ne peut plus être acceptée" do
    @booking.update!(status: :refused)
    sign_in users(:one)

    patch accept_dashboard_booking_url(@booking)

    assert_redirected_to dashboard_bookings_url
    assert_equal "Cette réservation ne peut plus être acceptée (statut : Rejeté).", flash[:alert]
    assert_predicate @booking.reload, :refused?
  end

  # --- Refus -----------------------------------------------------------------

  test "le propriétaire du joueur peut refuser la demande" do
    sign_in users(:one)

    patch refuse_dashboard_booking_url(@booking)

    assert_predicate @booking.reload, :refused?
    assert_redirected_to dashboard_bookings_url
    assert flash[:notice].present?
  end

  test "l'emprunteur et un club étranger ne peuvent pas refuser la demande" do
    [ users(:two), users(:three) ].each do |user|
      sign_in user

      patch refuse_dashboard_booking_url(@booking)

      assert_response :redirect
      assert flash[:alert].present?
      assert_predicate @booking.reload, :pending?
    end
  end
end
