class PostsController < ApplicationController
  # Skip authentication for index and show actions (allow public access)
  skip_before_action :authenticate_user!, only: [:index, :show]
  
  # Set up before actions for finding posts and checking ownership
  before_action :set_post, only: [:edit, :update, :destroy]
  before_action :ensure_owner!, only: [:edit, :update, :destroy]

  def index
    begin
      # Start with base query
      @posts = Post.published.includes(:user)
      
      # Apply search filter
      @posts = @posts.search(params[:search]) if params[:search].present?
      
      # Apply status filter
      @posts = @posts.with_status(params[:status]) if params[:status].present?
      
      # Apply user filter (only for logged-in users)
      if user_signed_in?
        if params[:user_filter] == "own"
          @posts = @posts.by_user(current_user)
        elsif params[:user_filter] == "others"
          @posts = @posts.where.not(user: current_user)
        end
      end
      
      # Apply date range filter with proper error handling
      start_date = nil
      end_date = nil
      
      if params[:start_date].present?
        begin
          start_date = Date.parse(params[:start_date])
        rescue ArgumentError, Date::Error
          flash.now[:alert] = "Invalid start date format. Please use YYYY-MM-DD format."
        end
      end
      
      if params[:end_date].present?
        begin
          end_date = Date.parse(params[:end_date])
        rescue ArgumentError, Date::Error
          flash.now[:alert] = "Invalid end date format. Please use YYYY-MM-DD format."
        end
      end
      
      @posts = @posts.date_range(start_date, end_date) if start_date || end_date
      
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
      
    rescue StandardError => e
      # Log the error and provide a fallback
      Rails.logger.error "Error in PostsController#index: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      
      # Fallback to simple query
      @posts = Post.published.includes(:user).order(created_at: :desc)
      @filter_params = {}
      @users = User.all if user_signed_in?
      
      flash.now[:alert] = "There was an error loading the posts. Showing all published posts instead."
    end
  end

  def show
    begin
      # Load post with comments for display
      @post = Post.includes(:user, comments: :user).friendly.find(params[:slug])
      
      # Check if user can view this post
      unless @post.published? || (user_signed_in? && @post.user == current_user)
        render file: Rails.root.join('public/404.html'), status: :not_found, layout: false
        return
      end
      
      # Initialize new comment for form
      @comment = @post.comments.build if user_signed_in?
      
      # Handle canonical URL redirect
      if request.path != post_path(@post)
        redirect_to @post, status: :moved_permanently
        return
      end
      
      fresh_when(@post)
    rescue ActiveRecord::RecordNotFound, FriendlyId::BlankError
      render file: Rails.root.join('public/404.html'), status: :not_found, layout: false
    rescue StandardError => e
      Rails.logger.error "Error in PostsController#show: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      render file: Rails.root.join('public/500.html'), status: :internal_server_error, layout: false
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
    @post = Post.includes(:user).friendly.find(params[:slug])
  rescue ActiveRecord::RecordNotFound, FriendlyId::BlankError
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
