class UserPolicy < ApplicationPolicy
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
    new?
  end

  def edit?
    user.present? && record == user
  end

  def update?
    edit?
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
