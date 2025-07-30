class CommentPolicy < ApplicationPolicy
  def index?
    true # Anyone can view comments on published posts
  end

  def show?
    record.post.published? || admin? || record.post.user == user
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
      else
        scope.joins(:post).where(posts: { status: 'published' })
      end
    end
  end
end 