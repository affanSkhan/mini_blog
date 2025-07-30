class Api::V1::AuthController < Api::V1::BaseController
  # Skip authentication for login/register endpoints
  skip_before_action :authenticate_user!, only: [:login, :register]
  
  # POST /api/v1/auth/login
  def login
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      token = user.generate_jwt
      render json: {
        success: true,
        data: {
          user: UserSerializer.new(user).as_json,
          token: token
        }
      }, status: :ok
    else
      render json: { 
        success: false, 
        error: 'Invalid email or password' 
      }, status: :unauthorized
    end
  end
  
  # POST /api/v1/auth/register
  def register
    user = User.new(user_params)
    
    if user.save
      token = user.generate_jwt
      render json: {
        success: true,
        data: {
          user: UserSerializer.new(user).as_json,
          token: token
        }
      }, status: :created
    else
      render json: { 
        success: false, 
        error: 'Registration failed',
        details: user.errors.full_messages 
      }, status: :unprocessable_entity
    end
  end
  
  # DELETE /api/v1/auth/logout
  def logout
    # In a real JWT implementation, you might want to blacklist the token
    # For now, we'll just return a success message
    render json: { 
      success: true, 
      message: 'Logged out successfully' 
    }, status: :ok
  end
  
  # GET /api/v1/auth/me
  def me
    render json: {
      success: true,
      data: UserSerializer.new(current_user).as_json
    }, status: :ok
  end
  
  private
  
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end 