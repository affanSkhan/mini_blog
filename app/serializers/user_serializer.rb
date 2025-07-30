class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :created_at, :updated_at, :admin
  
  # Only include admin status if the current user is an admin
  def admin
    object.admin? if scope&.admin?
  end
  
  # Include posts count if requested
  attribute :posts_count, if: :include_posts_count?
  
  def posts_count
    object.posts.count
  end
  
  private
  
  def include_posts_count?
    instance_options[:include_posts_count]
  end
end 