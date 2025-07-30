class Comment < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :post

  # Validations
  validates :body, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :user, presence: true
  validates :post, presence: true

  # Scopes for ordering comments
  scope :recent, -> { order(created_at: :desc) }
  scope :oldest, -> { order(created_at: :asc) }

  # Callback to ensure comment is associated with a published post
  validate :post_must_be_published, on: :create

  private

  def post_must_be_published
    return unless post.present?
    
    unless post.published?
      errors.add(:post, "must be published to receive comments")
    end
  end
end
