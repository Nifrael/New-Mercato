require "test_helper"

class BookingsControllerTest < ActionDispatch::IntegrationTest
  # players(:one) appartient au club one ; users(:two) est du club two,
  # c'est donc un emprunteur légitime pour ce joueur.
  setup do
    @player = players(:one)
    @valid_params = {
      booking: { start_date: Date.current + 1, end_date: Date.current + 4 }
    }
  end

  # --- Création d'une demande de location -----------------------------------

  test "un visiteur non connecté est redirigé vers la connexion" do
    assert_no_difference "Booking.count" do
      post player_bookings_url(@player), params: @valid_params
    end

    assert_redirected_to new_user_session_url
  end

  test "un utilisateur d'un autre club peut envoyer une demande de location" do
    sign_in users(:two)

    assert_difference "Booking.count", 1 do
      post player_bookings_url(@player), params: @valid_params
    end

    booking = Booking.last
    assert_predicate booking, :pending?
    assert_equal clubs(:two), booking.club # le club emprunteur est celui de l'utilisateur
    assert_equal 3 * @player.price_per_day, booking.total_price # 3 jours
    assert_redirected_to player_booking_url(@player, booking)
  end

  test "une demande dont la fin précède le début est refusée" do
    sign_in users(:two)
    invalid_params = {
      booking: { start_date: Date.current + 4, end_date: Date.current + 1 }
    }

    assert_no_difference "Booking.count" do
      post player_bookings_url(@player), params: invalid_params
    end

    assert_response :unprocessable_entity
    assert_equal "Date de fin doit être postérieure à la date de début.", flash[:alert]
  end

  test "une demande sans dates est refusée sans faire planter l'application" do
    sign_in users(:two)
    empty_params = { booking: { start_date: "", end_date: "" } }

    assert_no_difference "Booking.count" do
      post player_bookings_url(@player), params: empty_params
    end

    assert_response :unprocessable_entity
  end

  test "un club ne peut pas louer son propre joueur" do
    sign_in users(:one) # même club que players(:one)

    assert_no_difference "Booking.count" do
      post player_bookings_url(@player), params: @valid_params
    end

    assert_response :redirect
    assert_equal "Vous n'êtes pas autorisé à effectuer cette action ou accéder à cette section.", flash[:alert]
  end
end
