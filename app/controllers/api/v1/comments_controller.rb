class Api::V1::CommentsController < Api::V1::BaseController
  before_action :set_post
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :ensure_owner!, only: [:update, :destroy]
  
  # GET /api/v1/posts/:post_id/comments
  def index
    comments = @post.comments.includes(:user).order(created_at: :desc)
    
    # Pagination
    comments = comments.page(params[:page]).per(params[:per_page] || 20)
    
    render_success({
      comments: CommentSerializer.new(comments).as_json,
      meta: {
        total_count: comments.total_count,
        current_page: comments.current_page,
        total_pages: comments.total_pages
      }
    })
  end
  
  # GET /api/v1/posts/:post_id/comments/:id
  def show
    render_success(CommentSerializer.new(@comment).as_json)
  end
  
  # POST /api/v1/posts/:post_id/comments
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      # Send notification to post author (asynchronously)
      CommentNotificationJob.perform_later(@post.user.id, @comment.id)
      
      render_created(CommentSerializer.new(@comment).as_json)
    else
      render json: { 
        success: false, 
        error: 'Failed to create comment',
        details: @comment.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # PATCH /api/v1/posts/:post_id/comments/:id
  def update
    if @comment.update(comment_params)
      render_success(CommentSerializer.new(@comment).as_json)
    else
      render json: { 
        success: false, 
        error: 'Failed to update comment',
        details: @comment.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/posts/:post_id/comments/:id
  def destroy
    @comment.destroy
    render_deleted
  end
  
  private
  
  def set_post
    @post = Post.friendly.find(params[:post_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
  
  def set_comment
    @comment = @post.comments.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Comment not found' }, status: :not_found
  end
  
  def comment_params
    params.require(:comment).permit(:body)
  end
end 