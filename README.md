# 📌 Mini Blogging Platform (Rails + Devise + PostgreSQL)

## 🚀 Project Overview
A full-featured blogging platform where users can register, log in, manage their posts (draft/published), comment on posts, search and filter posts, and view personal dashboards. This project demonstrates user authentication, CRUD operations, nested routes, background jobs, API exposure, and an optional admin panel in Rails.

---

## 🧰 Tech Stack

- **Ruby on Rails 7.x**
- **Devise** for Authentication
- **PostgreSQL** as the database
- **Bootstrap 5** for UI
- **Sidekiq** or **DelayedJob** (optional for background jobs)
- **Token-based API authentication**

---

## 🔐 Authentication Features

- Implemented `Devise` for User model
- Users can:
  - Sign up, log in, edit profile, and change password
  - Are redirected to their dashboard after login

---

## ✍️ Post Management

- Only logged-in users can create, edit, or delete their own posts
- Each post has:
  - Title
  - Body
  - Status (`draft` or `published`)
  - Slug-based URLs (e.g., `/posts/my-first-blog`)
- Timestamps for post creation and update

---

## 💬 Comments System

- Authenticated users can comment on any published post
- Non-logged-in users can view posts and comments but cannot comment
- Each comment displays:
  - Commenter’s email
  - Timestamp
  - Only the comment owner can delete their comment

---

## 🔍 Search & Filtering

- Search bar: Find posts by title or content
- Filters:
  - Published posts only
  - User’s own posts
  - Posts within a date range

---

## 📋 User Dashboard

- Displays list of logged-in user’s posts
- Includes:
  - Post status
  - Number of comments
  - Action buttons (edit/delete)
  - Post preview snippet

---

## ⚙️ Background Job (Optional Bonus)

- Triggered when post status is changed to “Published”
- Simulated using Sidekiq/DelayedJob:
  - Sends email notification to user
  - Logs the event in `notifications` table

---

## 📡 API Endpoints (JSON)

- `/api/posts`: List all **published** posts
- `/api/posts/:id`: View a **published** post
- Token-based authentication for API access
- JSON output for mobile or third-party integrations

---

## 🛠 Admin Panel (Optional Bonus)

- Simple hardcoded admin login (non-Devise)
- Admin can:
  - View all users and posts
  - Delete any inappropriate content

---

## 🚦 How to Run the Project

### 1. Clone the repo

```bash
git clone https://github.com/your-username/mini-blog-platform.git
cd mini-blog-platform
```

### 2. Setup environment

```bash
bundle install
yarn install
rails db:setup
```

### 3. Run the server

```bash
rails server
```

### 4. Login with test credentials

* Email: `test@example.com`
* Password: `password123`

---

## ✅ Features Implemented

- ✅ Devise-based authentication
- ✅ CRUD operations for Posts
- ✅ Slug URLs for posts
- ✅ Comment system with ownership checks
- ✅ Search and filter posts
- ✅ Dashboard with stats and previews
- ✅ Optional background job support
- ✅ RESTful API with JSON + token
- ✅ (Optional) Admin moderation tools

---

## 👤 Test User Credentials

* Email: `test@example.com`
* Password: `password123`

---

## 💡 Suggestions for Improvement

- Add pagination for posts and comments
- Implement user avatars and post images
- Add email confirmation for new users
- Improve API with pagination and error handling
- Add more advanced admin features (analytics, user roles)
- Write RSpec tests for models, controllers, and API endpoints
- Deploy to Heroku, Render, or another cloud platform

---

**Enjoy blogging! 🚀**
