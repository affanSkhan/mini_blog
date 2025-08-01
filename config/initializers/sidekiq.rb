# Sidekiq configuration for Upstash Redis
# Docs: https://github.com/mperham/sidekiq/wiki/Using-Redis

if ENV["REDIS_URL"].present?
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV.fetch("REDIS_URL"),
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end

  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV.fetch("REDIS_URL"),
      ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE }
    }
  end

  Rails.application.config.active_job.queue_adapter = :sidekiq
else
  # Fallback to async adapter if Redis is not available
  Rails.application.config.active_job.queue_adapter = :async
end
