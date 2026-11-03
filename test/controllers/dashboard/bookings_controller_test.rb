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

  # Pipeline : onglets Reçues / Envoyées × colonnes En attente / Acceptées / Refusées.
  # Vu par le club one : bookings(:one) est REÇUE (pending), bookings(:two) est ENVOYÉE (pending).

  test "par défaut, l'onglet Reçues est actif et la demande en attente a ses actions" do
    sign_in users(:one)

    get dashboard_bookings_url

    assert_response :success
    assert_select ".segmented__item[aria-current=page][href=?]", dashboard_bookings_path
    assert_select "#column-pending .booking-card", count: 1, text: /#{players(:one).name}/
    assert_select "#column-pending form[action=?]", accept_dashboard_booking_path(@booking)
  end

  test "l'onglet Envoyées liste nos demandes, sans actions de décision" do
    sign_in users(:one)

    get dashboard_bookings_url(direction: "sent")

    assert_select ".segmented__item[aria-current=page][href=?]", dashboard_bookings_path(direction: "sent")
    assert_select "#column-pending .booking-card", count: 1, text: /#{players(:two).name}/
    assert_select ".booking-card form", count: 0
  end

  test "chaque demande est rangée dans la colonne de son statut, avec un compteur" do
    @booking.update!(status: :accepted)
    sign_in users(:one)

    get dashboard_bookings_url

    assert_select "#column-accepted .booking-card", text: /#{players(:one).name}/
    assert_select "#column-accepted .pipeline__count", text: "1"
    assert_select "#column-pending .booking-card", count: 0
    assert_select "#column-pending .pipeline__empty"
  end

  test "une direction inconnue retombe sur les demandes reçues" do
    sign_in users(:one)

    get dashboard_bookings_url(direction: "n-importe-quoi")

    assert_select ".segmented__item[aria-current=page][href=?]", dashboard_bookings_path
  end

  # --- Réservation inexistante ---------------------------------------------

  test "accepter une réservation inexistante renvoie une page 404" do
    sign_in users(:one)

    patch accept_dashboard_booking_url(id: 0)

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

  test "accepter depuis le tableau de bord ramène au tableau de bord" do
    sign_in users(:one)

    patch accept_dashboard_booking_url(@booking), headers: { "HTTP_REFERER" => dashboard_url }

    # Retour sur la même page : Turbo 8 la « morphe » (mise à jour sans rechargement).
    assert_redirected_to dashboard_url
  end

  test "refuser depuis le tableau de bord ramène au tableau de bord" do
    sign_in users(:one)

    patch refuse_dashboard_booking_url(@booking), headers: { "HTTP_REFERER" => dashboard_url }

    assert_redirected_to dashboard_url
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

  test "accepter une demande dont la période est déjà louée explique pourquoi" do
    # Une autre demande sur les mêmes dates a déjà été acceptée.
    Booking.create!(player: @booking.player, club: clubs(:three), total_price: 1, status: :accepted,
                    start_date: @booking.start_date, end_date: @booking.end_date)
    sign_in users(:one)

    patch accept_dashboard_booking_url(@booking)

    assert_equal "Ce joueur est déjà loué sur une partie de cette période.", flash[:alert]
    assert_predicate @booking.reload, :pending?
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
