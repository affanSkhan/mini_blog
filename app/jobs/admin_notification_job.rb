class AdminNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    user = User.find(user_id)
    
    # Only send admin notifications if there are admin users
    admin_users = User.where(admin: true)
    return if admin_users.empty?
    
    admin_users.each do |admin|
      UserMailer.admin_new_user_notification(user).deliver_now
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "AdminNotificationJob: User #{user_id} not found"
  rescue => e
    Rails.logger.error "AdminNotificationJob error: #{e.message}"
    raise e
  end
end 