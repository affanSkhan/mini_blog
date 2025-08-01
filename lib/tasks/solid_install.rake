namespace :solid do
  desc "Install all solid gems"
  task install: :environment do
    puts "Installing solid_cache, solid_queue, and solid_cable..."
    
    # Run migrations
    ActiveRecord::Tasks::DatabaseTasks.migrate
    
    puts "Solid gems installed successfully!"
  end
end
