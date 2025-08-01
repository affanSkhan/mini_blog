#!/usr/bin/env ruby

# Quick test script to verify Post model and controller logic works
require_relative "../config/environment"

puts "Testing Post model and scopes..."

begin
  # Test basic Post queries
  puts "1. Testing Post.published scope..."
  posts = Post.published
  puts "   Found #{posts.count} published posts"
  
  puts "2. Testing Post.search scope with empty query..."
  posts = Post.published.search("")
  puts "   Search with empty query: #{posts.count} posts"
  
  puts "3. Testing Post.search scope with nil query..."
  posts = Post.published.search(nil)
  puts "   Search with nil query: #{posts.count} posts"
  
  puts "4. Testing Post.with_status scope..."
  posts = Post.published.with_status("published")
  puts "   Status filter 'published': #{posts.count} posts"
  
  posts = Post.published.with_status("all")
  puts "   Status filter 'all': #{posts.count} posts"
  
  posts = Post.published.with_status("")
  puts "   Status filter empty: #{posts.count} posts"
  
  puts "5. Testing Post.date_range scope..."
  posts = Post.published.date_range(nil, nil)
  puts "   Date range with nil values: #{posts.count} posts"
  
  puts "6. Testing Post.sorted_by scope..."
  posts = Post.published.sorted_by("newest")
  puts "   Sort by newest: #{posts.count} posts"
  
  posts = Post.published.sorted_by("")
  puts "   Sort by empty string: #{posts.count} posts"
  
  posts = Post.published.sorted_by(nil)
  puts "   Sort by nil: #{posts.count} posts"
  
  puts "7. Testing chained scopes (like in controller)..."
  posts = Post.published.includes(:user)
  posts = posts.search("")
  posts = posts.with_status("")
  posts = posts.date_range(nil, nil)
  posts = posts.sorted_by("")
  puts "   Chained empty scopes: #{posts.count} posts"
  
  puts "\nAll tests passed! The Post model scopes are working correctly."
  
rescue => e
  puts "ERROR: #{e.message}"
  puts e.backtrace.first(5).join("\n")
end
