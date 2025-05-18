class ClubPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    true
  end

  def new?
    false
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

  def destroy?
    false
  end
  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.all
    end
  end
end
