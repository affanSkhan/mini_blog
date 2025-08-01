# bin/create_admin.rb

user = User.create!(
  email: "admin@example.com", 
  password: "password123",
  password_confirmation: "password123",
  admin: true
)

puts "✅ Admin created: #{user.email}"
puts "✅ Admin status: #{user.admin?}"
