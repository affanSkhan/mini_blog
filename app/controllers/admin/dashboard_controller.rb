class Admin::DashboardController < ApplicationController
  before_action :require_admin!

  def index
    @users = User.order(created_at: :desc)
    @total_users = User.count
    @total_posts = Post.count
    @published_posts = Post.published.count
    @draft_posts = Post.draft.count
    @total_comments = Comment.count
  end
end 