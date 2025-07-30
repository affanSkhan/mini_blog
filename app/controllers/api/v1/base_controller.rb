class Api::V1::BaseController < ApplicationController
  # Skip CSRF protection for API requests
  skip_before_action :verify_authenticity_token
  
  # Handle API-specific exceptions
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :bad_request
  
  # Set response format to JSON
  respond_to :json
  
  private
  
  # Authentication method for API
  def authenticate_user!
    unless current_user
      render json: { error: 'Authentication required' }, status: :unauthorized
    end
  end
  
  # Optional authentication - doesn't fail if no user
  def authenticate_user_optional
    # current_user will be nil if no valid token
    current_user
  end
  
  # Check if user owns the resource
  def ensure_owner!(resource)
    unless current_user && resource.user == current_user
      render json: { error: 'Access denied' }, status: :forbidden
    end
  end
  
  # Error responses
  def not_found(exception)
    render json: { error: 'Resource not found' }, status: :not_found
  end
  
  def unprocessable_entity(exception)
    render json: { 
      error: 'Validation failed', 
      details: exception.record.errors.full_messages 
    }, status: :unprocessable_entity
  end
  
  def bad_request(exception)
    render json: { error: 'Bad request', details: exception.message }, status: :bad_request
  end
  
  # Success responses
  def render_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end
  
  def render_created(data)
    render json: { success: true, data: data }, status: :created
  end
  
  def render_deleted
    render json: { success: true, message: 'Resource deleted successfully' }, status: :ok
  end
end 