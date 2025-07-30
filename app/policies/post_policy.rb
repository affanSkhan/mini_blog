class PostPolicy < ApplicationPolicy
  def index?
    true # Anyone can view published posts
  end

  def show?
    record.published? || admin? || owner?
  end

  def create?
    user.present?
  end

  def update?
    admin? || owner?
  end

  def destroy?
    admin? || owner?
  end

  class Scope < Scope
    def resolve
      if user&.admin?
        scope.all
      elsif user
        scope.where(user: user).or(scope.published)
      else
        scope.published
      end
    end
  end
end 