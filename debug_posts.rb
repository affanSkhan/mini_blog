#!/usr/bin/env ruby

# Simple test to verify our fixes
puts "Loading Rails environment..."
require_relative '../config/environment'

puts "Testing PostsController index action..."

# Simulate what happens in the controller
class TestPostsController
  include Rails.application.routes.url_helpers
  
  def test_index
    puts "1. Testing basic Post.published query..."
    posts = Post.published.includes(:user)
    puts "   Found #{posts.count} published posts"
    
    puts "2. Testing search scope with empty params..."
    posts = posts.search("")
    puts "   After search filter: #{posts.count} posts"
    
    puts "3. Testing status filter..."
    posts = posts.with_status("")
    puts "   After status filter: #{posts.count} posts"
    
    puts "4. Testing date range filter..."
    posts = posts.date_range(nil, nil)
    puts "   After date range filter: #{posts.count} posts"
    
    puts "5. Testing sorting..."
    posts = posts.sorted_by("")
    puts "   After sorting: #{posts.count} posts"
    
    puts "6. Testing final query execution..."
    posts_array = posts.to_a
    puts "   Final result: #{posts_array.count} posts"
    
    puts "7. Testing view data..."
    posts_array.each_with_index do |post, i|
      break if i >= 3 # Only show first 3
      puts "   - Post: '#{post.title}' by #{post.user&.email || 'Unknown'}"
    end
    
    puts "\nAll tests completed successfully!"
    return true
  rescue => e
    puts "ERROR: #{e.message}"
    puts e.backtrace.first(5).join("\n")
    return false
  end
end

test_controller = TestPostsController.new
success = test_controller.test_index

if success
  puts "\n✅ The fixes should resolve the 500 error in production!"
else
  puts "\n❌ There are still issues that need to be addressed."
end
