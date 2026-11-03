require "test_helper"

# Le job recalcule chaque jour le statut des joueurs dont un prêt COMMENCE aujourd'hui
# ou s'est TERMINÉ hier (planifié dans config/recurring.yml).
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

  test "le job est planifié chaque jour en production" do
    recurring = YAML.load_file(Rails.root.join("config/recurring.yml"))

    task = recurring.dig("production", "update_player_availability")
    assert_equal "UpdatePlayerAvailabilityJob", task&.fetch("class")
    assert_match(/every day/, task&.fetch("schedule").to_s)
  end
end
