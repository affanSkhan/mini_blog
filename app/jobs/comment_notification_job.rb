class CommentNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(post_author_id, comment_id)
    post_author = User.find(post_author_id)
    comment = Comment.find(comment_id)
    
    # Don't send notification if the commenter is the post author
    return if comment.user == post_author
    
    UserMailer.new_comment_notification(post_author, comment).deliver_now
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error "CommentNotificationJob: Record not found - #{e.message}"
  rescue => e
    Rails.logger.error "CommentNotificationJob error: #{e.message}"
    raise e
  end
end 