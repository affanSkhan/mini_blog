# Mini Blog API Documentation

## Base URL
```
http://localhost:3000/api/v1
```

## Authentication
The API uses JWT (JSON Web Tokens) for authentication. Include the token in the Authorization header:
```
Authorization: Bearer <your_jwt_token>
```

## Endpoints

### Authentication

#### Login
```
POST /auth/login
```

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "created_at": "2025-07-30T05:10:42.201Z",
      "updated_at": "2025-07-30T05:15:58.698Z"
    },
    "token": "eyJhbGciOiJIUzI1NiJ9..."
  }
}
```

#### Register
```
POST /auth/register
```

**Request Body:**
```json
{
  "user": {
    "email": "newuser@example.com",
    "password": "password123",
    "password_confirmation": "password123"
  }
}
```

#### Get Current User
```
GET /auth/me
```
*Requires authentication*

#### Logout
```
DELETE /auth/logout
```
*Requires authentication*

### Posts

#### List Posts
```
GET /posts
```

**Query Parameters:**
- `search` - Search in title and body
- `status` - Filter by status (published, draft, all)
- `user_filter` - Filter by user (own, others, all) *requires auth*
- `start_date` - Filter by start date (YYYY-MM-DD)
- `end_date` - Filter by end date (YYYY-MM-DD)
- `sort` - Sort by (newest, oldest, most_commented, title_asc, title_desc)
- `page` - Page number for pagination
- `per_page` - Items per page (default: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "posts": [
      {
        "id": 1,
        "title": "My First Post",
        "body": "This is the content...",
        "status": "published",
        "slug": "my-first-post",
        "created_at": "2025-07-30T05:10:42.201Z",
        "updated_at": "2025-07-30T05:15:58.698Z",
        "comments_count": 3,
        "user": {
          "id": 1,
          "email": "user@example.com",
          "created_at": "2025-07-30T05:10:42.201Z",
          "updated_at": "2025-07-30T05:15:58.698Z"
        }
      }
    ],
    "meta": {
      "total_count": 10,
      "current_page": 1,
      "total_pages": 1
    }
  }
}
```

#### Get Single Post
```
GET /posts/:slug
```

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "My First Post",
    "body": "This is the full content...",
    "status": "published",
    "slug": "my-first-post",
    "created_at": "2025-07-30T05:10:42.201Z",
    "updated_at": "2025-07-30T05:15:58.698Z",
    "comments_count": 3,
    "user": {
      "id": 1,
      "email": "user@example.com",
      "created_at": "2025-07-30T05:10:42.201Z",
      "updated_at": "2025-07-30T05:15:58.698Z"
    },
    "comments": [
      {
        "id": 1,
        "body": "Great post!",
        "created_at": "2025-07-30T05:15:58.698Z",
        "updated_at": "2025-07-30T05:15:58.698Z",
        "time_ago": "2 hours ago",
        "user": {
          "id": 2,
          "email": "commenter@example.com",
          "created_at": "2025-07-30T05:12:00.000Z",
          "updated_at": "2025-07-30T05:12:00.000Z"
        }
      }
    ]
  }
}
```

#### Create Post
```
POST /posts
```
*Requires authentication*

**Request Body:**
```json
{
  "post": {
    "title": "New Post Title",
    "body": "This is the post content...",
    "status": "draft"
  }
}
```

#### Update Post
```
PATCH /posts/:slug
```
*Requires authentication and ownership*

**Request Body:**
```json
{
  "post": {
    "title": "Updated Title",
    "body": "Updated content...",
    "status": "published"
  }
}
```

#### Delete Post
```
DELETE /posts/:slug
```
*Requires authentication and ownership*

### Comments

#### List Comments for a Post
```
GET /posts/:post_slug/comments
```

**Query Parameters:**
- `page` - Page number for pagination
- `per_page` - Items per page (default: 20)

#### Get Single Comment
```
GET /posts/:post_slug/comments/:id
```

#### Create Comment
```
POST /posts/:post_slug/comments
```
*Requires authentication*

**Request Body:**
```json
{
  "comment": {
    "body": "This is my comment..."
  }
}
```

#### Update Comment
```
PATCH /posts/:post_slug/comments/:id
```
*Requires authentication and ownership*

**Request Body:**
```json
{
  "comment": {
    "body": "Updated comment..."
  }
}
```

#### Delete Comment
```
DELETE /posts/:post_slug/comments/:id
```
*Requires authentication and ownership*

## Error Responses

### 400 Bad Request
```json
{
  "error": "Bad request",
  "details": "Parameter missing: email"
}
```

### 401 Unauthorized
```json
{
  "error": "Authentication required"
}
```

### 403 Forbidden
```json
{
  "error": "Access denied"
}
```

### 404 Not Found
```json
{
  "error": "Resource not found"
}
```

### 422 Unprocessable Entity
```json
{
  "success": false,
  "error": "Failed to create post",
  "details": ["Title can't be blank", "Body can't be blank"]
}
```

## Testing with cURL

### Login
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

### Get Posts (Public)
```bash
curl http://localhost:3000/api/v1/posts
```

### Create Post (Authenticated)
```bash
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{"post": {"title": "API Test", "body": "Testing via API", "status": "published"}}'
```

### Get Current User
```bash
curl http://localhost:3000/api/v1/auth/me \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

## Mobile App Integration

This API is designed to work seamlessly with mobile apps built with:
- **Flutter**
- **React Native**
- **Ionic**
- **Native iOS/Android**

The JWT authentication provides secure, stateless authentication perfect for mobile applications. 