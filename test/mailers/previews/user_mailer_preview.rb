# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    user = User.first || User.create!(email: "test@example.com", password: "password123", admin: true)
    UserMailer.welcome_email(user)
  end

  def new_comment_notification
    user = User.first || User.create!(email: "test@example.com", password: "password123", admin: true)
    post = Post.first || Post.create!(title: "Test Post", body: "Test body", status: "published", user: user)
    comment = Comment.first || Comment.create!(body: "Test comment", user: user, post: post)
    UserMailer.new_comment_notification(post.user, comment)
  end

  def admin_new_user_notification
    user = User.first || User.create!(email: "newuser@example.com", password: "password123")
    UserMailer.admin_new_user_notification(user)
  end

  def post_published_notification
    user = User.first || User.create!(email: "test@example.com", password: "password123")
    post = Post.first || Post.create!(title: "Test Post", body: "Test body", status: "published", user: user)
    UserMailer.post_published_notification(user, post)
  end
end 