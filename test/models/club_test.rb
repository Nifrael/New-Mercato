require "test_helper"

class ClubTest < ActiveSupport::TestCase
  # --- Dirigeant du club -----------------------------------------------------

  test "le dirigeant est le membre au rôle dirigeant, pas un employé" do
    # Le club one a deux membres : users(:one) (dirigeant) et users(:employe_one).
    assert_equal users(:one), clubs(:one).dirigeant
  end

  test "un club sans dirigeant renvoie nil" do
    users(:one).update!(role: :employe)

    assert_nil clubs(:one).dirigeant
  end

  # --- Effectif actuel -------------------------------------------------------
  # players(:one) appartient au club one, players(:two) au club two.

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

  test "sans prêt en cours, l'effectif est composé des joueurs du club" do
    assert_equal [ players(:one) ], clubs(:one).current_squad.to_a
  end

  test "un joueur prêté à un autre club ne fait plus partie de l'effectif" do
    create_active_loan(player: players(:one), borrower: clubs(:two))

    assert_not_includes clubs(:one).current_squad, players(:one)
  end

  test "un joueur emprunté à un autre club fait partie de l'effectif" do
    create_active_loan(player: players(:one), borrower: clubs(:two))

    assert_equal [ players(:one), players(:two) ].sort_by(&:id), clubs(:two).current_squad.sort_by(&:id)
  end

  test "une demande en attente ne modifie pas l'effectif" do
    # bookings(:one) : le club two demande players(:one), statut pending.
    assert_includes clubs(:one).current_squad, players(:one)
    assert_not_includes clubs(:two).current_squad, players(:one)
  end
end
