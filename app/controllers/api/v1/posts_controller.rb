class Api::V1::PostsController < Api::V1::BaseController
  before_action :set_post, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  before_action :ensure_owner!, only: [:update, :destroy]
  
  # GET /api/v1/posts
  def index
    # Start with published posts for guests, all posts for logged-in users
    posts = current_user ? Post.all : Post.published
    
    # Apply search filter
    posts = posts.search(params[:search]) if params[:search].present?
    
    # Apply status filter
    posts = posts.with_status(params[:status]) if params[:status].present?
    
    # Apply user filter (only for logged-in users)
    if current_user && params[:user_filter].present?
      case params[:user_filter]
      when "own"
        posts = posts.by_user(current_user)
      when "others"
        posts = posts.where.not(user: current_user)
      end
    end
    
    # Apply date range filter
    if params[:start_date].present? || params[:end_date].present?
      start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
      end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil
      posts = posts.date_range(start_date, end_date)
    end
    
    # Apply sorting
    posts = posts.sorted_by(params[:sort] || "newest")
    
    # Pagination (optional)
    posts = posts.page(params[:page]).per(params[:per_page] || 20)
    
    render_success({
      posts: PostSerializer.new(posts).as_json,
      meta: {
        total_count: posts.total_count,
        current_page: posts.current_page,
        total_pages: posts.total_pages
      }
    })
  rescue Date::Error
    render json: { error: 'Invalid date format. Use YYYY-MM-DD' }, status: :bad_request
  end
  
  # GET /api/v1/posts/:id
  def show
    # Check if user can view this post
    unless @post.published? || (current_user && @post.user == current_user)
      render json: { error: 'Post not found or not accessible' }, status: :not_found
      return
    end
    
    render_success(PostSerializer.new(@post, include_comments: true).as_json)
  end
  
  # POST /api/v1/posts
  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      render_created(PostSerializer.new(@post).as_json)
    else
      render json: { 
        success: false, 
        error: 'Failed to create post',
        details: @post.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # PATCH /api/v1/posts/:id
  def update
    if @post.update(post_params)
      render_success(PostSerializer.new(@post).as_json)
    else
      render json: { 
        success: false, 
        error: 'Failed to update post',
        details: @post.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/posts/:id
  def destroy
    @post.destroy
    render_deleted
  end
  
  private
  
  def set_post
    @post = Post.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Post not found' }, status: :not_found
  end
  
  def post_params
    params.require(:post).permit(:title, :body, :status)
  end
end 