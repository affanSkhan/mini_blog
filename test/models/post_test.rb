require "test_helper"

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one) # Assuming you have a user fixture
    @post = @user.posts.build(title: "Test Post", body: "Test content", status: :draft)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "title should be present" do
    @post.title = "   "
    assert_not @post.valid?
  end

  test "body should be present" do
    @post.body = "   "
    assert_not @post.valid?
  end

  test "status should be present" do
    @post.status = nil
    assert_not @post.valid?
  end

  test "title should be unique per user" do
    duplicate_post = @post.dup
    @post.save
    assert_not duplicate_post.valid?
  end

  test "title can be same for different users" do
    other_user = users(:two) # Assuming you have another user fixture
    other_post = other_user.posts.build(title: @post.title, body: "Other content", status: :draft)
    @post.save
    assert other_post.valid?
  end

  test "should generate slug from title" do
    @post.title = "My Test Post Title"
    @post.save
    assert_equal "my-test-post-title", @post.slug
  end

  test "published scope should return only published posts" do
    published_post = @user.posts.create!(title: "Published", body: "Content", status: :published)
    draft_post = @user.posts.create!(title: "Draft", body: "Content", status: :draft)
    
    assert_includes Post.published, published_post
    assert_not_includes Post.published, draft_post
  end

  test "draft scope should return only draft posts" do
    published_post = @user.posts.create!(title: "Published", body: "Content", status: :published)
    draft_post = @user.posts.create!(title: "Draft", body: "Content", status: :draft)
    
    assert_includes Post.draft, draft_post
    assert_not_includes Post.draft, published_post
  end
end
