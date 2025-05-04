class BookingPolicy < ApplicationPolicy
  def index?
    user.present? && user.club.present?
  end

  def show?
    index?
    record.club.present? && record.player&.club.present? &&
    (user.club_id == record.club_id || user.club_id == record.player.club_id)
  end

  def new?
    index?
    user.club_id != player.club_id
  end

  def create?
    new?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      unless user&.club_id
        scope.none
      end
      scope.joins(player: :club).where("bookings.club_id = :club_id OR players.club_id = :club_id").distinct
    end
  end
end
