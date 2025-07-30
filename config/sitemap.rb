# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://yourdomain.com"

SitemapGenerator::Sitemap.create do
  # Root path
  add '/', changefreq: 'daily', priority: 1.0

  # Static pages
  add '/about', changefreq: 'monthly'
  add '/contact', changefreq: 'monthly'

  # Published posts
  Post.published.find_each do |post|
    add post_path(post), lastmod: post.updated_at, changefreq: 'weekly', priority: 0.8
  end
end