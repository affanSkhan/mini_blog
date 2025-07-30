class SitemapRegenJob < ApplicationJob
  queue_as :default

  def perform
    system("bundle exec rake sitemap:refresh")
  end
end