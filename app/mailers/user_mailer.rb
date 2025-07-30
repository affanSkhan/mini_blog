class UserMailer < ApplicationMailer
  default from: 'Mini Blog <noreply@miniblog.com>'

  def welcome_email(user)
    @user = user
    @login_url = new_user_session_url
    
    mail(
      to: @user.email,
      subject: "Welcome to Mini Blog, #{@user.email}!"
    )
  end

  def new_comment_notification(post_author, comment)
    @post_author = post_author
    @comment = comment
    @post = comment.post
    @commenter = comment.user
    
    mail(
      to: @post_author.email,
      subject: "New comment on your post: #{@post.title}"
    )
  end

  def admin_new_user_notification(user)
    @user = user
    @admin_users = User.where(admin: true)
    
    @admin_users.each do |admin|
      @admin = admin
      mail(
        to: admin.email,
        subject: "New user signed up: #{@user.email}"
      )
    end
  end

  def post_published_notification(user, post)
    @user = user
    @post = post
    
    mail(
      to: @user.email,
      subject: "Your post '#{@post.title}' has been published!"
    )
  end
end 