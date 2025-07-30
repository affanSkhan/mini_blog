class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at
  
  belongs_to :user, serializer: UserSerializer
  
  # Include post info if requested
  attribute :post_info, if: :include_post_info?
  
  def post_info
    {
      id: object.post.id,
      title: object.post.title,
      slug: object.post.slug
    }
  end
  
  # Include time ago for better UX
  attribute :time_ago
  
  def time_ago
    ActionController::Base.helpers.time_ago_in_words(object.created_at)
  end
  
  private
  
  def include_post_info?
    instance_options[:include_post_info]
  end
end 