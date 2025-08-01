class Post < ApplicationRecord
  # Friendly ID for slug-based URLs
  extend FriendlyId
  friendly_id :title, use: :slugged

  # Associations
  belongs_to :user
  has_many :comments, dependent: :destroy, counter_cache: true

  # Enums for status
  enum :status, { draft: 0, published: 1 }

  # Validations
  validates :title, presence: true, uniqueness: { scope: :user_id, message: "must be unique per user" }
  validates :body, presence: true
  validates :status, presence: true

  # Scopes for filtering posts
  scope :published, -> { where(status: :published) }
  scope :draft, -> { where(status: :draft) }
  scope :by_user, ->(user) { where(user: user) }
  
  # Search scope
  scope :search, ->(query) {
    return all if query.blank?
    where("title ILIKE ? OR body ILIKE ?", "%#{query}%", "%#{query}%")
  }
  
  # Date range scope
  scope :date_range, ->(start_date, end_date) {
    scope = all
    if start_date.present? && end_date.present?
      scope = scope.where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    elsif start_date.present?
      scope = scope.where("created_at >= ?", start_date.beginning_of_day)
    elsif end_date.present?
      scope = scope.where("created_at <= ?", end_date.end_of_day)
    end
    scope
  }
  
  # Status filter scope
  scope :with_status, ->(status) {
    return all if status.blank? || status == "all"
    where(status: status)
  }
  
  # User filter scope
  scope :by_user_filter, ->(user_id) {
    where(user_id: user_id) if user_id.present? && user_id != "all"
  }
  
  # Sort scope
  scope :sorted_by, ->(sort_option) {
    case sort_option
    when "newest"
      order(created_at: :desc)
    when "oldest"
      order(created_at: :asc)
    when "most_commented"
      left_joins(:comments)
        .group(:id)
        .order("COUNT(comments.id) DESC, created_at DESC")
    when "title_asc"
      order(title: :asc)
    when "title_desc"
      order(title: :desc)
    else
      order(created_at: :desc) # default
    end
  }

  # Callback to ensure slug is generated
  before_validation :generate_slug, on: :create
  after_commit :regenerate_sitemap, on: [:create, :update, :destroy]

  # Override FriendlyId slug candidates for better uniqueness
  def should_generate_new_friendly_id?
    title_changed? || slug.blank?
  end

  # Must be public for FriendlyId
  def normalize_friendly_id(input)
    input.to_s.downcase.parameterize.truncate(80, omission: '')
  end

  # Canonical URL for SEO
  def canonical_url
    Rails.application.routes.url_helpers.post_url(self)
  end

  private

  def generate_slug
    # Generate slug from title if not present
    if title.present? && slug.blank?
      self.slug = title.parameterize.truncate(80, omission: '')
    end
  end

  def regenerate_sitemap
    SitemapRegenJob.perform_later
  end
end
