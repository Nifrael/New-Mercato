class PlayerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def edit?
    user.present? && record.club.present? && user.club_id == record.club_id
  end

  def update?
    edit?
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
