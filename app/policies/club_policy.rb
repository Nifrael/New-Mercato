class ClubPolicy < ApplicationPolicy
  # Les clubs sont publics en lecture.
  # Création, modification et suppression : interdites à tous
  # (héritées d'ApplicationPolicy, qui refuse tout par défaut).
  def index?
    true
  end

  def show?
    true
  end

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
