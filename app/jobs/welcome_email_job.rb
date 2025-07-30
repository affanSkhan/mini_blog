class WelcomeEmailJob < ApplicationJob
  queue_as :mailers

  def perform(user_id)
    user = User.find(user_id)
    UserMailer.welcome_email(user).deliver_now
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "WelcomeEmailJob: User #{user_id} not found"
  rescue => e
    Rails.logger.error "WelcomeEmailJob error: #{e.message}"
    raise e
  end
end 