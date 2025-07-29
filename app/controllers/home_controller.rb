class HomeController < ApplicationController
  # Skip authentication for homepage - allow unauthenticated users
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # Homepage for unauthenticated users
  end
end
