class Admin::UsersController < ApplicationController
  before_action :require_admin!
  before_action :set_user, only: [:show, :update, :destroy, :toggle_admin, :posts]

  def index
    @users = User.order(created_at: :desc)
  end

  def show
    @posts = @user.posts.order(created_at: :desc).limit(5)
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User updated."
    else
      flash[:alert] = @user.errors.full_messages.to_sentence
    end
    redirect_to admin_users_path
  end

  def toggle_admin
    @user.update(admin: !@user.admin?)
    flash[:notice] = @user.admin? ? "User promoted to admin." : "User demoted to regular user."
    redirect_to admin_users_path
  end

  def destroy
    # Soft delete: mark as deleted, do not actually destroy
    @user.update(deleted_at: Time.current)
    flash[:notice] = "User soft-deleted."
    redirect_to admin_users_path
  end

  def posts
    @posts = @user.posts.order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:admin)
  end
end 