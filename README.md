# Mini Blog - Ruby on Rails 7 Application

A simple and elegant blogging platform built with Ruby on Rails 7, PostgreSQL, and Devise for authentication.

## 🚀 Phase 1: Authentication Implementation

This project implements a complete authentication system using Devise with the following features:

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

### Controllers
- `app/controllers/application_controller.rb` - Added authentication helpers and redirection logic
- `app/controllers/home_controller.rb` - Homepage controller (allows unauthenticated access)
- `app/controllers/dashboard_controller.rb` - Protected dashboard controller

### Models
- `app/models/user.rb` - Devise User model with authentication features

### Views
- `app/views/layouts/application.html.erb` - Added Bootstrap 5 and flash messages
- `app/views/home/index.html.erb` - Beautiful homepage with sign up/sign in cards
- `app/views/dashboard/index.html.erb` - User dashboard with profile information
- `app/views/devise/sessions/new.html.erb` - Styled sign in form
- `app/views/devise/registrations/new.html.erb` - Styled sign up form
- `app/views/devise/registrations/edit.html.erb` - Styled profile edit form
- `app/views/devise/shared/_links.html.erb` - Styled navigation links
- `app/views/devise/shared/_error_messages.html.erb` - Styled error messages

### Configuration
- `config/routes.rb` - Updated with Devise routes and custom routes
- `config/database.yml` - PostgreSQL configuration
- `Gemfile` - Added Devise gem and Bootstrap 5 CDN

### Database
- `db/migrate/*_devise_create_users.rb` - Users table migration

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

## 🎨 UI Features

- **Bootstrap 5 Integration:** Modern, responsive design
- **Flash Messages:** Success and error notifications
- **Form Styling:** Professional Bootstrap form components
- **Navigation:** Clean navbar with user information
- **Cards Layout:** Organized content presentation
- **Responsive Design:** Works on desktop and mobile devices

## 🚀 Next Steps (Future Phases)

- Phase 2: Blog Post Management (CRUD operations)
- Phase 3: User Profiles and Avatars
- Phase 4: Comments and Interactions
- Phase 5: Search and Filtering
- Phase 6: Admin Panel

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
