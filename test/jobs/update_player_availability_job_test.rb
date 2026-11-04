require "test_helper"

# Le job recalcule chaque jour le statut Loué / Disponible des joueurs
# (planifié dans config/recurring.yml). Il doit rattraper les jours où il n'a pas tourné.
class UpdatePlayerAvailabilityJobTest < ActiveJob::TestCase
  def accepted_loan(player, from:, to:)
    Booking.create!(player: player, club: clubs(:three), total_price: 1, status: :pending,
                    start_date: Date.current + from, end_date: Date.current + to).tap do |loan|
      loan.update_column(:status, Booking.statuses[:accepted])
    end
  end

  test "un prêt terminé hier rend le joueur à nouveau disponible" do
    accepted_loan(players(:one), from: -5, to: -1)
    players(:one).update_column(:status, Player.statuses[:rented])

    UpdatePlayerAvailabilityJob.perform_now

    assert_predicate players(:one).reload, :available?
  end

  test "un prêt qui commence aujourd'hui rend le joueur loué" do
    accepted_loan(players(:two), from: 0, to: 5)

    UpdatePlayerAvailabilityJob.perform_now

    assert_predicate players(:two).reload, :rented?
  end

  test "un prêt terminé depuis longtemps (job manqué) rend le joueur disponible" do
    accepted_loan(players(:one), from: -30, to: -20)
    players(:one).update_column(:status, Player.statuses[:rented])

    UpdatePlayerAvailabilityJob.perform_now

    assert_predicate players(:one).reload, :available?
  end

  test "un prêt commencé avant aujourd'hui (job manqué) rend le joueur loué" do
    accepted_loan(players(:two), from: -3, to: 5)

    UpdatePlayerAvailabilityJob.perform_now

    assert_predicate players(:two).reload, :rented?
  end

  test "un joueur rendu indisponible par son club le reste" do
    players(:one).update_column(:status, Player.statuses[:unavailable])

    UpdatePlayerAvailabilityJob.perform_now

    assert_predicate players(:one).reload, :unavailable?
  end

  test "le job est planifié chaque jour en production" do
    recurring = YAML.load_file(Rails.root.join("config/recurring.yml"))

    task = recurring.dig("production", "update_player_availability")
    assert_equal "UpdatePlayerAvailabilityJob", task&.fetch("class")
    assert_match(/every day/, task&.fetch("schedule").to_s)
  end
end
