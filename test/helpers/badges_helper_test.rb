require "test_helper"

class BadgesHelperTest < ActionView::TestCase
  # --- Réservations ----------------------------------------------------------

  test "une réservation en attente a un badge d'avertissement" do
    assert_dom_equal(
      '<span class="badge badge--warning">En attente</span>',
      status_badge(Booking.new(status: :pending))
    )
  end

  test "une réservation acceptée a un badge de succès" do
    assert_dom_equal(
      '<span class="badge badge--success">Accepté</span>',
      status_badge(Booking.new(status: :accepted))
    )
  end

  test "une réservation refusée a un badge de danger" do
    assert_dom_equal(
      '<span class="badge badge--danger">Rejeté</span>',
      status_badge(Booking.new(status: :refused))
    )
  end

  test "on peut afficher un autre statut que celui de l'enregistrement" do
    assert_dom_equal(
      '<span class="badge badge--success">Accepté</span>',
      status_badge(Booking.new(status: :pending), status: :accepted)
    )
  end

  # --- Jours restants d'un prêt ----------------------------------------------

  test "le badge des jours restants passe en avertissement à 3 jours ou moins" do
    travel_to Date.new(2026, 11, 3) do
      far = Booking.new(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 11))
      near = Booking.new(start_date: Date.new(2026, 11, 1), end_date: Date.new(2026, 11, 6))

      assert_dom_equal '<span class="badge badge--success">J-8</span>', days_left_badge(far)
      assert_dom_equal '<span class="badge badge--warning">J-3</span>', days_left_badge(near)
    end
  end

  # --- Joueurs ---------------------------------------------------------------

  test "chaque statut de joueur a son badge" do
    assert_dom_equal '<span class="badge badge--success">Disponible</span>', status_badge(Player.new(status: :available))
    assert_dom_equal '<span class="badge badge--warning">Loué</span>', status_badge(Player.new(status: :rented))
    assert_dom_equal '<span class="badge badge--danger">Indisponible</span>', status_badge(Player.new(status: :unavailable))
  end
end
