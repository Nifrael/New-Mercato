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

  # --- Demandes reçues -------------------------------------------------------
  # bookings(:one) : le club two demande players(:one) (club one) → reçue par le club one.
  # bookings(:two) : le club one demande players(:two) (club two) → ENVOYÉE par le club one.

  test "les demandes reçues portent sur nos joueurs, quel que soit leur statut" do
    bookings(:one).update!(status: :refused)

    assert_equal [ bookings(:one) ], clubs(:one).received_bookings.to_a
  end

  test "les demandes reçues en attente excluent les autres statuts" do
    assert_equal [ bookings(:one) ], clubs(:one).received_pending_bookings.to_a

    bookings(:one).update!(status: :accepted)
    assert_empty clubs(:one).received_pending_bookings
  end

  # --- Prêts en cours (empruntés ET prêtés) ----------------------------------

  test "un prêt en cours apparaît chez l'emprunteur et chez le prêteur" do
    loan = create_active_loan(player: players(:one), borrower: clubs(:two))

    assert_includes clubs(:two).active_loans, loan # emprunteur
    assert_includes clubs(:one).active_loans, loan # prêteur (propriétaire du joueur)
    assert_not_includes clubs(:three).active_loans, loan
  end

  test "les prêts en cours se séparent en empruntés et prêtés selon le point de vue" do
    loan = create_active_loan(player: players(:one), borrower: clubs(:two))

    assert_equal [ loan ], clubs(:two).borrowed_loans.to_a # le club two emprunte
    assert_empty clubs(:two).lent_loans
    assert_equal [ loan ], clubs(:one).lent_loans.to_a     # le club one prête son joueur
    assert_empty clubs(:one).borrowed_loans
  end

  test "les demandes en attente et les prêts terminés ne sont pas des prêts en cours" do
    finished = create_active_loan(player: players(:one), borrower: clubs(:two))
    finished.update!(start_date: Date.current - 10, end_date: Date.current - 2)

    assert_empty clubs(:one).active_loans # bookings(:one) est pending, `finished` est passé
  end

  test "une demande en attente ne modifie pas l'effectif" do
    # bookings(:one) : le club two demande players(:one), statut pending.
    assert_includes clubs(:one).current_squad, players(:one)
    assert_not_includes clubs(:two).current_squad, players(:one)
  end
end
