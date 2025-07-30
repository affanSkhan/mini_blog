class Admin::AnalyticsController < ApplicationController
  before_action :require_admin!

  def index
    # Get date range for analytics (last 30 days by default)
    @start_date = params[:start_date]&.to_date || 30.days.ago.to_date
    @end_date = params[:end_date]&.to_date || Date.current

    # User analytics
    @total_users = User.count
    @new_users_this_month = User.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day).count
    @admin_users = User.where(admin: true).count

    # Post analytics
    @total_posts = Post.count
    @published_posts = Post.published.count
    @draft_posts = Post.draft.count
    @posts_this_month = Post.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day).count

    # Comment analytics
    @total_comments = Comment.count
    @comments_this_month = Comment.where(created_at: @start_date.beginning_of_day..@end_date.end_of_day).count

    # Top authors
    @top_authors = User.joins(:posts)
                       .group('users.id')
                       .order('COUNT(posts.id) DESC')
                       .limit(5)
                       .pluck('users.email', 'COUNT(posts.id)')

    # Most commented posts
    @most_commented_posts = Post.joins(:comments)
                                .group('posts.id')
                                .order('COUNT(comments.id) DESC')
                                .limit(5)
                                .pluck('posts.title', 'COUNT(comments.id)')

    # Recent activity
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_posts = Post.includes(:user).order(created_at: :desc).limit(5)
    @recent_comments = Comment.includes(:user, :post).order(created_at: :desc).limit(5)
  end

  def export
    respond_to do |format|
      format.csv do
        case params[:type]
        when 'users'
          send_data export_users_csv, filename: "users-#{Date.current}.csv"
        when 'posts'
          send_data export_posts_csv, filename: "posts-#{Date.current}.csv"
        when 'comments'
          send_data export_comments_csv, filename: "comments-#{Date.current}.csv"
        else
          redirect_to admin_analytics_path, alert: 'Invalid export type'
        end
      end
    end
  end

  private

  def export_users_csv
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Email', 'Admin', 'Posts Count', 'Comments Count', 'Created At', 'Updated At']
      
      User.includes(:posts, :comments).find_each do |user|
        csv << [
          user.id,
          user.email,
          user.admin?,
          user.posts.count,
          user.comments.count,
          user.created_at,
          user.updated_at
        ]
      end
    end
  end

  def export_posts_csv
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Title', 'Status', 'Author', 'Comments Count', 'Created At', 'Updated At']
      
      Post.includes(:user, :comments).find_each do |post|
        csv << [
          post.id,
          post.title,
          post.status,
          post.user.email,
          post.comments.count,
          post.created_at,
          post.updated_at
        ]
      end
    end
  end

  def export_comments_csv
    require 'csv'
    
    CSV.generate(headers: true) do |csv|
      csv << ['ID', 'Body', 'Author', 'Post Title', 'Created At', 'Updated At']
      
      Comment.includes(:user, :post).find_each do |comment|
        csv << [
          comment.id,
          comment.body,
          comment.user.email,
          comment.post.title,
          comment.created_at,
          comment.updated_at
        ]
      end
    end
  end
end 