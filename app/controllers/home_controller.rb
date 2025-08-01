class HomeController < ApplicationController
  # Skip authentication for homepage - allow unauthenticated users
  skip_before_action :authenticate_user!, only: [:index, :api_explorer]

  def index
    # Homepage for unauthenticated users
  end

  def api_explorer
    # API Explorer page
  end
end
