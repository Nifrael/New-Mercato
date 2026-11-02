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

  # --- Joueurs ---------------------------------------------------------------

  test "chaque statut de joueur a son badge" do
    assert_dom_equal '<span class="badge badge--success">Disponible</span>', status_badge(Player.new(status: :available))
    assert_dom_equal '<span class="badge badge--warning">Loué</span>', status_badge(Player.new(status: :rented))
    assert_dom_equal '<span class="badge badge--danger">Indisponible</span>', status_badge(Player.new(status: :unavailable))
  end
end
