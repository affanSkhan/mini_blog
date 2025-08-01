class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  # Commented out to avoid potential issues in production
  # allow_browser versions: :modern

  # Include Pundit for authorization
  include Pundit::Authorization

  # Devise authentication helper methods
  before_action :authenticate_user!

  # Redirect to dashboard after successful login
  def after_sign_in_path_for(resource)
    dashboard_path
  end

  # Redirect to login page if user tries to access protected pages without authentication
  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  # Admin-only access control
  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  # JWT Authentication for API
  private

  def authenticate_user_from_token!
    return unless request.headers['Authorization'].present?
    
    token = request.headers['Authorization'].split(' ').last
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: 'HS256' })
      user_id = decoded_token[0]['id']
      @current_user = User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      @current_user = nil
    end
  end

  def current_user
    @current_user ||= super || authenticate_user_from_token!
  end
end
