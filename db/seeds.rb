# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Seeding database..."

# Create a test user if it doesn't exist
test_user = User.find_or_create_by!(email: 'test@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true  # Make this user an admin for testing
end

puts "✅ Created test user: #{test_user.email} (Admin)"

# Create sample posts
sample_posts = [
  {
    title: "Welcome to Mini Blog",
    body: "This is your first post on Mini Blog! Welcome to our community of writers and readers. Here you can share your thoughts, ideas, and stories with the world.

## Getting Started

1. Create your account
2. Write your first post
3. Share with the community

We're excited to see what you'll create!",
    status: "published",
    user: test_user
  },
  {
    title: "The Art of Blogging",
    body: "Blogging is more than just writing - it's about connecting with your audience and sharing valuable content. Here are some tips for successful blogging:

### 1. Know Your Audience
Understand who you're writing for and what they want to read.

### 2. Be Consistent
Regular posting helps build your audience and establish your voice.

### 3. Engage with Readers
Respond to comments and encourage discussion.

### 4. Use Clear Headings
Structure your content with proper headings for better readability.

Happy blogging!",
    status: "published",
    user: test_user
  },
  {
    title: "My Draft Post",
    body: "This is a draft post that only I can see. It's perfect for working on ideas before publishing them to the world.

I can edit this post anytime and publish it when I'm ready.",
    status: "draft",
    user: test_user
  }
]

sample_posts.each do |post_data|
  post = Post.find_or_create_by!(title: post_data[:title], user: post_data[:user]) do |p|
    p.body = post_data[:body]
    p.status = post_data[:status]
  end
  puts "✅ Created post: #{post.title} (#{post.status})"
end

puts "🎉 Seeding completed!"
