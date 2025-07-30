class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.integer :status, null: false, default: 0
      t.string :slug, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # Add indexes for better performance
    add_index :posts, :slug, unique: true
    add_index :posts, :status
    add_index :posts, [:user_id, :title], unique: true
  end
end
