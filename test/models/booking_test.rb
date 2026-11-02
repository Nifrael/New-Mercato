require "test_helper"

class BookingTest < ActiveSupport::TestCase
  # --- Validations ----------------------------------------------------------

  test "un booking sans dates est invalide (et ne plante pas)" do
    booking = Booking.new(player: players(:one), club: clubs(:two), total_price: 1000)

    assert_not booking.valid?
    assert booking.errors.added?(:start_date, :blank)
    assert booking.errors.added?(:end_date, :blank)
  end

  test "les messages d'erreur par défaut sont traduits en français" do
    booking = Booking.new(player: players(:one), club: clubs(:two), total_price: 1000)
    booking.valid?

    assert_includes booking.errors.full_messages, "Date de début doit être rempli(e)"
  end

  test "le prix total ne peut pas être calculé sans dates" do
    booking = Booking.new(player: players(:one), club: clubs(:two))

    assert_nil booking.calculate_total_price(1000)
  end
  # --- Scope active : prêts acceptés et en cours aujourd'hui ----------------

  # Crée un booking accepté entre deux dates (club two emprunte le joueur du club one).
  def create_accepted_booking(start_date:, end_date:)
    Booking.create!(
      player: players(:one),
      club: clubs(:two),
      start_date: start_date,
      end_date: end_date,
      total_price: 1000,
      status: :accepted
    )
  end

  test "active inclut un prêt accepté en cours" do
    travel_to Time.zone.local(2026, 11, 2, 12, 0) do
      booking = create_accepted_booking(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 5))

      assert_includes Booking.active, booking
    end
  end

  test "active exclut une demande en attente, même si les dates sont en cours" do
    travel_to Time.zone.local(2026, 11, 2, 12, 0) do
      booking = bookings(:one) # pending

      assert_not_includes Booking.active, booking
    end
  end

  # Simule un serveur réglé sur un autre fuseau que Paris (cas typique en production),
  # pour que le test donne le même résultat quelle que soit la machine qui le lance.
  def with_server_time_zone(zone)
    original = ENV["TZ"]
    ENV["TZ"] = zone
    yield
  ensure
    ENV["TZ"] = original
  end

  test "active se base sur la date à Paris, pas sur celle du serveur" do
    # 23h30 UTC le 2 novembre = 00h30 le 3 novembre à Paris.
    # Un prêt qui finit le 2 novembre n'est donc plus actif pour un utilisateur français.
    with_server_time_zone("UTC") do
      travel_to Time.utc(2026, 11, 2, 23, 30) do
        booking = create_accepted_booking(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 2))

        assert_not_includes Booking.active, booking
      end
    end
  end
end
