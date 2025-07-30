# Sidekiq configuration
# https://github.com/mperham/sidekiq/wiki/Configuration

Sidekiq.configure_server do |config|
  # Configure Redis connection
  config.redis = { 
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    namespace: "mini_blog"
  }
  
  # Configure logging
  config.logger.level = Logger::INFO
  
  # Configure error handling
  config.error_handlers << ->(ex, context) do
    Rails.logger.error "Sidekiq error: #{ex.message}"
    Rails.logger.error "Context: #{context}"
  end
end

Sidekiq.configure_client do |config|
  # Configure Redis connection for client
  config.redis = { 
    url: ENV.fetch("REDIS_URL", "redis://localhost:6379/0"),
    namespace: "mini_blog"
  }
end

# Configure ActiveJob to use Sidekiq
Rails.application.config.active_job.queue_adapter = :sidekiq 