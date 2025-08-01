#!/bin/bash

echo "🚀 Deploying Mini Blog to Railway..."

# Check if Railway CLI is installed
if ! command -v railway &> /dev/null; then
    echo "❌ Railway CLI not found. Installing..."
    npm install -g @railway/cli
fi

# Login to Railway
echo "🔐 Logging into Railway..."
railway login

# Deploy
echo "📦 Deploying application..."
railway up

# Run migrations
echo "🗄️ Running database migrations..."
railway run rails db:migrate

# Create admin user if needed
echo "👤 Creating admin user..."
railway run rails console -e production << EOF
unless User.find_by(email: 'admin@example.com')
  User.create!(
    email: 'admin@example.com',
    password: 'password123',
    password_confirmation: 'password123',
    admin: true
  )
  puts "✅ Admin user created: admin@example.com"
else
  puts "ℹ️ Admin user already exists"
end
EOF

echo "✅ Deployment complete!"
echo "🌐 Your app is live at: $(railway status | grep 'Domain' | awk '{print $2}')" 