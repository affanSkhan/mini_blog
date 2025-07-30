class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || owner?
  end

  def create?
    admin?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin?
  end

  def toggle_admin?
    admin?
  end

  def soft_delete?
    admin?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      else
        scope.none
      end
    end
  end
end 