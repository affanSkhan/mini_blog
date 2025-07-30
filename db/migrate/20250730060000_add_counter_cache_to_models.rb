class AddCounterCacheToModels < ActiveRecord::Migration[8.0]
  def change
    # Add counter cache columns
    add_column :users, :posts_count, :integer, default: 0, null: false
    add_column :users, :comments_count, :integer, default: 0, null: false
    add_column :posts, :comments_count, :integer, default: 0, null: false

    # Add indexes for better performance
    add_index :users, :posts_count
    add_index :users, :comments_count
    add_index :posts, :comments_count
    add_index :posts, :created_at
    add_index :users, :created_at
  end
end 