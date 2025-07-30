RailsAdmin.config do |config|
  # Require admin access for all Rails Admin actions
  config.authorize_with do
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this area."
      redirect_to main_app.root_path
    end
  end

  # Set the application name
  config.main_app_name = ['Mini Blog', 'Admin']

  # Configure models
  config.included_models = ['User', 'Post', 'Comment']

  # User configuration
  config.model 'User' do
    list do
      field :id
      field :email
      field :admin
      field :created_at
      field :updated_at
      field :posts_count do
        label 'Posts'
      end
      field :comments_count do
        label 'Comments'
      end
    end

    show do
      field :id
      field :email
      field :admin
      field :created_at
      field :updated_at
      field :posts
      field :comments
    end

    edit do
      field :email
      field :password
      field :password_confirmation
      field :admin
    end

    export do
      field :id
      field :email
      field :admin
      field :created_at
      field :updated_at
      field :posts_count
      field :comments_count
    end
  end

  # Post configuration
  config.model 'Post' do
    list do
      field :id
      field :title
      field :status
      field :user
      field :comments_count
      field :created_at
      field :updated_at
    end

    show do
      field :id
      field :title
      field :body
      field :status
      field :slug
      field :user
      field :comments
      field :created_at
      field :updated_at
    end

    edit do
      field :title
      field :body
      field :status
      field :user
    end

    export do
      field :id
      field :title
      field :body
      field :status
      field :slug
      field :user
      field :comments_count
      field :created_at
      field :updated_at
    end
  end

  # Comment configuration
  config.model 'Comment' do
    list do
      field :id
      field :body
      field :user
      field :post
      field :created_at
    end

    show do
      field :id
      field :body
      field :user
      field :post
      field :created_at
      field :updated_at
    end

    edit do
      field :body
      field :user
      field :post
    end

    export do
      field :id
      field :body
      field :user
      field :post
      field :created_at
      field :updated_at
    end
  end

  # Custom dashboard
  config.model 'Dashboard' do
    object_label_method do
      :dashboard_label_method
    end
  end

  # Configure actions
  config.actions do
    dashboard do
      statistics false
    end

    index
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    # Custom actions
    collection :export_csv do
      only ['User', 'Post', 'Comment']
      link_icon 'icon-download'
    end
  end
end 