# Mini Blog - Ruby on Rails 7 Application

A simple and elegant blogging platform built with Ruby on Rails 7, PostgreSQL, and Devise for authentication.

## 🚀 Phase 1: Authentication Implementation ✅

This project implements a complete authentication system using Devise with the following features:

## 📝 Phase 2: Posts System ✅

This project implements a complete blog posts system with the following features:

### ✅ Implemented Features

1. **Post Model with Full CRUD Operations**
   - Post creation, editing, updating, and deletion
   - Draft and published status management
   - Friendly URLs using slugs
   - User ownership and access control

2. **Advanced Access Control**
   - Guests can only view published posts
   - Logged-in users can view all their own posts (including drafts)
   - Users can only edit/delete their own posts
   - Proper authentication and authorization

3. **Modern UI with Bootstrap 5**
   - Responsive post listing with cards
   - Professional post forms with validation
   - Status badges (draft/published)
   - Clean post display with proper formatting

4. **Enhanced Dashboard Integration**
   - User dashboard shows recent posts
   - Quick access to create new posts
   - Post status indicators
   - Navigation to all posts

### ✅ Post System Features

- **Friendly URLs:** Posts use slugs instead of IDs (e.g., `/posts/my-awesome-post`)
- **Status Management:** Draft and published states with proper visibility
- **Rich Content:** Support for markdown-style formatting
- **User Ownership:** Complete user-post association with proper permissions
- **Validation:** Comprehensive form validation with user-friendly error messages
- **Performance:** Database indexes for optimal query performance

## 🚀 Phase 1: Authentication Implementation

### ✅ Implemented Features

1. **User Authentication with Devise**
   - User sign up with email and password
   - User login/logout functionality
   - Edit profile (email and password)
   - Change password functionality
   - Account deletion

2. **Route Protection & Redirection**
   - Redirect to dashboard after successful login
   - Redirect to login page for unauthenticated users trying to access protected pages
   - Homepage accessible to unauthenticated users

3. **Modern UI with Bootstrap 5**
   - Responsive design with Bootstrap 5
   - Professional styling for all forms
   - Flash messages for user feedback
   - Clean and intuitive navigation

4. **User Dashboard**
   - Protected dashboard page for authenticated users
   - User information display
   - Navigation to edit profile and sign out

## 🛠️ Setup Instructions

### Prerequisites

- Ruby 3.3.0 or higher
- Rails 8.0.2
- PostgreSQL
- Bundler

### Database Setup

#### For Windows:
1. Install PostgreSQL for Windows
2. Create a PostgreSQL user with username `postgres` and password `postgres`
3. Update `config/database.yml` if using different credentials

#### For WSL (Ubuntu):
```bash
# Install PostgreSQL
sudo apt update
sudo apt install postgresql postgresql-contrib libpq-dev

# Create PostgreSQL user
sudo -u postgres createuser -s postgres
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"
```

### Application Setup

1. **Clone and install dependencies:**
   ```bash
   bundle install
   ```

2. **Create and setup database:**
   ```bash
   rails db:create
   rails db:migrate
   ```

3. **Start the Rails server:**
   ```bash
   rails server
   ```

4. **Access the application:**
   - Open your browser and go to `http://localhost:3000`
   - You should see the homepage with sign up and sign in options

## 📁 Files Changed/Created

### Phase 1: Authentication

#### Controllers
- `app/controllers/application_controller.rb` - Added authentication helpers and redirection logic
- `app/controllers/home_controller.rb` - Homepage controller (allows unauthenticated access)
- `app/controllers/dashboard_controller.rb` - Protected dashboard controller

#### Models
- `app/models/user.rb` - Devise User model with authentication features

#### Views
- `app/views/layouts/application.html.erb` - Added Bootstrap 5 and flash messages
- `app/views/home/index.html.erb` - Beautiful homepage with sign up/sign in cards
- `app/views/dashboard/index.html.erb` - User dashboard with profile information
- `app/views/devise/sessions/new.html.erb` - Styled sign in form
- `app/views/devise/registrations/new.html.erb` - Styled sign up form
- `app/views/devise/registrations/edit.html.erb` - Styled profile edit form
- `app/views/devise/shared/_links.html.erb` - Styled navigation links
- `app/views/devise/shared/_error_messages.html.erb` - Styled error messages

#### Configuration
- `config/routes.rb` - Updated with Devise routes and custom routes
- `config/database.yml` - PostgreSQL configuration
- `Gemfile` - Added Devise gem and Bootstrap 5 CDN

#### Database
- `db/migrate/*_devise_create_users.rb` - Users table migration

### Phase 2: Posts System

#### Models
- `app/models/post.rb` - Post model with validations, associations, and friendly_id
- `app/models/user.rb` - Updated with posts association

#### Controllers
- `app/controllers/posts_controller.rb` - Full CRUD operations with access control

#### Views
- `app/views/posts/index.html.erb` - Post listing with cards and status badges
- `app/views/posts/show.html.erb` - Individual post display with action buttons
- `app/views/posts/new.html.erb` - New post form wrapper
- `app/views/posts/edit.html.erb` - Edit post form wrapper
- `app/views/posts/_form.html.erb` - Shared form partial with validation
- `app/views/dashboard/index.html.erb` - Updated with user's posts display
- `app/views/home/index.html.erb` - Updated with posts link

#### Configuration
- `config/routes.rb` - Added posts resources with friendly_id support
- `Gemfile` - Added friendly_id gem for slug generation

#### Database
- `db/migrate/*_create_posts.rb` - Posts table with indexes and constraints
- `db/seeds.rb` - Sample data for testing

#### Tests
- `test/models/post_test.rb` - Comprehensive model tests

## 🔐 Authentication Flow

1. **Unauthenticated Users:**
   - Can access homepage (`/`)
   - Can sign up (`/users/sign_up`)
   - Can sign in (`/users/sign_in`)

2. **Authenticated Users:**
   - Automatically redirected to dashboard (`/dashboard`) after login
   - Can access dashboard with user information
   - Can edit profile (`/users/edit`)
   - Can sign out (redirects to homepage)

3. **Protected Routes:**
   - Dashboard requires authentication
   - Unauthenticated users are redirected to sign in page

## 📝 Posts System Flow

1. **Public Access:**
   - Anyone can view published posts (`/posts`)
   - Individual published posts are publicly accessible
   - Post listing shows only published content

2. **Authenticated Users:**
   - Can create new posts (`/posts/new`)
   - Can edit their own posts (`/posts/:slug/edit`)
   - Can delete their own posts
   - Can view their own draft posts
   - Dashboard shows their recent posts

3. **Access Control:**
   - Users can only edit/delete their own posts
   - Draft posts are only visible to the author
   - Published posts are visible to everyone
   - Proper error handling for unauthorized access

4. **URL Structure:**
   - Posts use friendly URLs with slugs (e.g., `/posts/my-awesome-post`)
   - Automatic slug generation from post titles
   - SEO-friendly URLs for better discoverability

## 🎨 UI Features

- **Bootstrap 5 Integration:** Modern, responsive design
- **Flash Messages:** Success and error notifications
- **Form Styling:** Professional Bootstrap form components
- **Navigation:** Clean navbar with user information
- **Cards Layout:** Organized content presentation
- **Responsive Design:** Works on desktop and mobile devices

## 🚀 Next Steps (Future Phases)

- ✅ Phase 1: Authentication System (Complete)
- ✅ Phase 2: Posts System (Complete)
- Phase 3: Comments System
  - Comment model with user associations
  - Nested comments (replies)
  - Comment moderation features
  - Real-time comment updates
- Phase 4: User Profiles and Avatars
  - User profile pages
  - Avatar upload functionality
  - Bio and social links
  - User post archives
- Phase 5: Search and Filtering
  - Full-text search functionality
  - Category/tag system
  - Advanced filtering options
  - Search result highlighting
- Phase 6: Admin Panel
  - Admin user management
  - Content moderation tools
  - Analytics dashboard
  - System configuration

## 🐛 Troubleshooting

### Database Connection Issues
If you encounter database connection errors:
1. Ensure PostgreSQL is running
2. Check database credentials in `config/database.yml`
3. Verify PostgreSQL user permissions

### Gem Installation Issues
If you encounter psych gem issues on Windows:
- The project includes a compatible version of psych (4.0.6)
- If issues persist, try using WSL for development

## 📝 Code Comments

The code includes comprehensive comments explaining:
- Authentication logic and redirection
- Route protection mechanisms
- Bootstrap styling classes
- Devise configuration
- Database setup requirements

---

**Note:** This is Phase 1 of the Mini Blog application. The authentication system is fully functional and ready for the next phase of development.
