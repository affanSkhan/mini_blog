class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

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
end
