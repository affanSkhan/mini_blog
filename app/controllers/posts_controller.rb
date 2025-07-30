class PostsController < ApplicationController
  # Skip authentication for index and show actions (allow public access)
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  # Set up before actions for finding posts and checking ownership
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  def index
    # Start with published posts for guests, all posts for logged-in users
    @posts = user_signed_in? ? Post.all : Post.published
    
    # Apply search filter
    @posts = @posts.search(params[:search])
    
    # Apply status filter
    @posts = @posts.with_status(params[:status])
    
    # Apply user filter (only for logged-in users)
    if user_signed_in?
      if params[:user_filter] == "own"
        @posts = @posts.by_user(current_user)
      elsif params[:user_filter] == "others"
        @posts = @posts.where.not(user: current_user)
      end
    end
    
    # Apply date range filter
    start_date = params[:start_date].present? ? Date.parse(params[:start_date]) : nil
    end_date = params[:end_date].present? ? Date.parse(params[:end_date]) : nil
    @posts = @posts.date_range(start_date, end_date)
    
    # Apply sorting
    @posts = @posts.sorted_by(params[:sort])
    
    # Store filter params for view
    @filter_params = {
      search: params[:search],
      status: params[:status],
      user_filter: params[:user_filter],
      start_date: params[:start_date],
      end_date: params[:end_date],
      sort: params[:sort]
    }
    
    # Get all users for filter dropdown (only for logged-in users)
    @users = User.all if user_signed_in?
  rescue Date::Error
    # Handle invalid date format
    @posts = user_signed_in? ? Post.all : Post.published
    @posts = @posts.order(created_at: :desc)
    flash.now[:alert] = "Invalid date format. Please use YYYY-MM-DD format."
  end

  def show
    if request.path != post_path(@post)
      return redirect_to @post, status: :moved_permanently
    end
    # Check if user can view this post
    unless @post.published? || (user_signed_in? && @post.user == current_user)
      redirect_to posts_path, alert: "Post not found or not accessible."
      return
    end
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # Post ownership already checked by ensure_owner!
  end

  def update
    # Post ownership already checked by ensure_owner!
    if @post.update(post_params)
      redirect_to @post, notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Post ownership already checked by ensure_owner!
    @post.destroy
    redirect_to posts_path, notice: "Post was successfully deleted."
  end

  private

  def set_post
    @post = Post.friendly.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Post not found."
  end

  def ensure_owner!
    unless user_signed_in? && @post.user == current_user
      redirect_to posts_path, alert: "You can only edit your own posts."
    end
  end

  def post_params
    params.require(:post).permit(:title, :body, :status)
  end
end
