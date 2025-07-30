class DashboardController < ApplicationController
  # Dashboard requires authentication (inherited from ApplicationController)
  
  def index
    # Dashboard for authenticated users
    @user = current_user
    
    # Get user's posts with filtering
    @posts = @user.posts
    
    # Apply search filter
    @posts = @posts.search(params[:search])
    
    # Apply status filter
    @posts = @posts.with_status(params[:status])
    
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
      start_date: params[:start_date],
      end_date: params[:end_date],
      sort: params[:sort]
    }
  rescue Date::Error
    # Handle invalid date format
    @posts = @user.posts.order(created_at: :desc)
    flash.now[:alert] = "Invalid date format. Please use YYYY-MM-DD format."
  end
end
