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

  # --- Pas de chevauchement avec une location acceptée -----------------------
  # Location acceptée de players(:one) du 10 au 20 (bornes incluses).

  def accept_loan_of_player_one
    Booking.create!(player: players(:one), club: clubs(:two), status: :accepted, total_price: 1,
                    start_date: Date.current + 10, end_date: Date.current + 20)
  end

  def request_player_one(from:, to:, club: clubs(:three))
    Booking.new(player: players(:one), club: club, total_price: 1,
                start_date: Date.current + from, end_date: Date.current + to)
  end

  test "une demande qui chevauche une location acceptée est refusée" do
    accept_loan_of_player_one

    request = request_player_one(from: 18, to: 25)

    assert_not request.valid?
    assert_includes request.errors[:base], "Ce joueur est déjà loué sur une partie de cette période."
  end

  test "une demande qui commence le jour où la location se termine chevauche aussi" do
    accept_loan_of_player_one

    assert_not request_player_one(from: 20, to: 25).valid?
  end

  test "une demande juste après la location est possible" do
    accept_loan_of_player_one

    assert request_player_one(from: 21, to: 25).valid?
  end

  test "deux demandes EN ATTENTE sur les mêmes dates peuvent coexister" do
    request_player_one(from: 10, to: 20, club: clubs(:two)).save!

    assert request_player_one(from: 10, to: 20).valid?
  end

  test "on ne peut pas accepter une demande si le joueur est déjà loué sur la période" do
    first = request_player_one(from: 10, to: 20, club: clubs(:two)).tap(&:save!)
    second = request_player_one(from: 15, to: 25).tap(&:save!)

    first.accept!

    assert_not second.reload.may_accept?
  end

  # --- Acceptation et statut du joueur ----------------------------------------

  test "accepter un prêt qui commence plus tard ne rend pas le joueur Loué tout de suite" do
    loan = request_player_one(from: 10, to: 20, club: clubs(:two)).tap(&:save!)

    loan.accept!

    assert_predicate players(:one).reload, :available?
  end

  test "accepter un prêt qui commence aujourd'hui rend le joueur Loué" do
    loan = request_player_one(from: 0, to: 5, club: clubs(:two)).tap(&:save!)

    loan.accept!

    assert_predicate players(:one).reload, :rented?
  end

  # --- Joueur indisponible -----------------------------------------------------

  test "on ne peut pas demander un joueur que son club a rendu indisponible" do
    players(:one).update!(status: :unavailable)

    request = request_player_one(from: 30, to: 35)

    assert_not request.valid?
    assert_includes request.errors[:base], "Ce joueur n'est pas proposé à la location pour le moment."
  end

  # --- Durée et avancement d'un prêt (états dérivés des dates) ---------------

  test "la durée est le nombre de jours entre le début et la fin" do
    booking = Booking.new(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 15))

    assert_equal 14, booking.duration_in_days
  end

  test "jours restants et progression d'un prêt en cours" do
    booking = Booking.new(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 11))

    travel_to Date.new(2026, 11, 4) do
      assert_equal 7, booking.days_left
      assert_equal 30, booking.progress_percent
    end
  end

  test "la progression reste entre 0 et 100 avant et après le prêt" do
    booking = Booking.new(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 11))

    travel_to(Date.new(2026, 10, 20)) { assert_equal 0, booking.progress_percent }
    travel_to(Date.new(2026, 12, 1)) do
      assert_equal 100, booking.progress_percent
      assert_equal 0, booking.days_left
    end
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
