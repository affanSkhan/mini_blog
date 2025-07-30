class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_post

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    if @comment.save
      # Send notification to post author (asynchronously)
      CommentNotificationJob.perform_later(@post.user.id, @comment.id)
      
      flash[:notice] = "Comment posted!"
    else
      flash[:alert] = @comment.errors.full_messages.to_sentence
    end
    redirect_to post_path(@post)
  end

  def destroy
    @comment = @post.comments.find(params[:id])
    if @comment.user == current_user
      @comment.destroy
      flash[:notice] = "Comment deleted."
    else
      flash[:alert] = "You can only delete your own comments."
    end
    redirect_to post_path(@post)
  end

  private

  def set_post
    @post = Post.friendly.find(params[:post_slug] || params[:post_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end
