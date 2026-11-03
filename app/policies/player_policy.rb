class PlayerPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  # edit? est hérité d'ApplicationPolicy : il renvoie update?.
  def update?
    user.present? && record.club_id.present? && user.club_id == record.club_id
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
