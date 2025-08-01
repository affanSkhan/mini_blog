class HealthController < ApplicationController
  skip_before_action :authenticate_user!
  
  def check
    begin
      # Test database connection
      Post.connection.execute("SELECT 1")
      
      # Test basic Post query
      posts_count = Post.count
      published_count = Post.published.count
      
      # Test scopes
      search_test = Post.published.search("").count
      status_test = Post.published.with_status("").count
      sort_test = Post.published.sorted_by("").count
      
      render json: {
        status: "ok",
        database: "connected",
        posts_total: posts_count,
        posts_published: published_count,
        scopes_working: {
          search: search_test,
          status: status_test,
          sort: sort_test
        },
        timestamp: Time.current
      }
    rescue => e
      render json: {
        status: "error",
        error: e.message,
        timestamp: Time.current
      }, status: 500
    end
  end
  
  def posts_test
    begin
      # Simulate the posts controller index action
      posts = Post.published.includes(:user)
      posts = posts.search(params[:search]) if params[:search].present?
      posts = posts.with_status(params[:status]) if params[:status].present?
      posts = posts.date_range(nil, nil)
      posts = posts.sorted_by(params[:sort])
      
      posts_array = posts.limit(10).to_a
      
      render json: {
        status: "ok",
        count: posts_array.count,
        posts: posts_array.map { |p| { id: p.id, title: p.title, slug: p.slug } },
        timestamp: Time.current
      }
    rescue => e
      render json: {
        status: "error",
        error: e.message,
        backtrace: e.backtrace.first(10),
        timestamp: Time.current
      }, status: 500
    end
  end
end
