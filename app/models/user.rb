class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :posts, dependent: :destroy, counter_cache: true
  has_many :comments, dependent: :destroy, counter_cache: true

  # Validations
  validates :email, presence: true, uniqueness: true

  # Soft delete
  default_scope { where(deleted_at: nil) }

  def deleted?
    deleted_at.present?
  end

  # Role check
  def admin?
    self.admin
  end

  # Callbacks for email notifications
  after_create_commit :send_welcome_email
  after_create_commit :notify_admins

  # JWT token generation
  def generate_jwt
    JWT.encode(
      { 
        id: id, 
        email: email, 
        exp: 24.hours.from_now.to_i 
      },
      Rails.application.credentials.secret_key_base
    )
  end

  private

  def send_welcome_email
    WelcomeEmailJob.perform_later(id)
  end

  def notify_admins
    AdminNotificationJob.perform_later(id)
  end
end
