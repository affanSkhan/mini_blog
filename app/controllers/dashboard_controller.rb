class DashboardController < ApplicationController
  # Dashboard requires authentication (inherited from ApplicationController)
  
  def index
    # Dashboard for authenticated users
    @user = current_user
  end
end
