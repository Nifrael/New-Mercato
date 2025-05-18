class BookingPolicy < ApplicationPolicy
  def index?
    user.present? && user.club.present?
  end

  def show?
    user.present? && user.club.present? &&
    record.club.present? && record.player&.club.present? &&
    (user.club_id == record.club_id || user.club_id == record.player.club_id)
  end

  def new?
    user.present? && user.club.present?
  end

  def create?
    user.present? && user.club.present? &&
    record.club.present? && record.player&.club.present? &&
    record.club == user.club &&
    record.club_id != record.player.club_id
  end

  def update?
    user.present? && user.club.present? &&
    record.club.present? && record.player&.club.present? &&
    user.club_id == record.player.club_id
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      unless user&.club_id
        scope.none
      end
      club_id = user.club_id
      scope.left_joins(player: :club).where("bookings.club_id = :club_id OR players.club_id = :club_id", club_id: club_id).distinct
    end
  end
end
