class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :status, :slug, :created_at, :updated_at, :comments_count
  
  belongs_to :user, serializer: UserSerializer
  
  # Include comments if requested
  has_many :comments, serializer: CommentSerializer, if: :include_comments?
  
  # Include truncated body for list views
  attribute :body_truncated, if: :truncate_body?
  
  def body_truncated
    object.body.truncate(150)
  end
  
  def comments_count
    object.comments.count
  end
  
  # Include user info if requested
  attribute :user_info, if: :include_user_info?
  
  def user_info
    {
      id: object.user.id,
      email: object.user.email
    }
  end
  
  private
  
  def include_comments?
    instance_options[:include_comments]
  end
  
  def truncate_body?
    instance_options[:truncate_body]
  end
  
  def include_user_info?
    instance_options[:include_user_info]
  end
end 