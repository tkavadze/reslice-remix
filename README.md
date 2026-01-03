# Kanban Board

A full-featured Kanban board SaaS web application for task management, built with Ruby on Rails 7.1, Hotwire (Turbo + Stimulus), and Tailwind CSS.

## Features

- **User Authentication**: Sign up, sign in, and sign out functionality
- **Board Management**: Create, edit, and delete Kanban boards
- **Column Management**: Add, rename, and remove columns within boards
- **Card Management**: Create, edit, and delete task cards
- **Drag and Drop**: Reorder cards within and across columns
- **Card Details**: Add descriptions, due dates, and priority levels
- **Real-time Updates**: Powered by Hotwire Turbo Streams
- **Responsive Design**: Works on desktop and mobile devices

## Tech Stack

- **Backend**: Ruby on Rails 7.1
- **Database**: SQLite3
- **Frontend**: Hotwire (Turbo + Stimulus)
- **Styling**: Tailwind CSS 4
- **JavaScript**: Importmaps

## Getting Started

### Prerequisites

- Ruby 3.3.6
- SQLite3

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd kanban-board
   ```

2. Install dependencies:
   ```bash
   bundle install
   ```

3. Set up the database:
   ```bash
   bin/rails db:setup
   ```

4. Start the server:
   ```bash
   bin/rails server
   ```

5. Visit `http://localhost:3000` in your browser

### Demo Account

After running seeds, you can sign in with:
- Email: `demo@example.com`
- Password: `password123`

## Development

### Running Tests

```bash
bin/rails test
```

### Database Commands

```bash
# Create database
bin/rails db:create

# Run migrations
bin/rails db:migrate

# Seed database
bin/rails db:seed

# Reset database
bin/rails db:reset
```

## Models

- **User**: Has many boards, authenticates with email/password
- **Board**: Belongs to user, has many columns
- **Column**: Belongs to board, has many cards, has position
- **Card**: Belongs to column, has title, description, due date, priority, and position

## API Endpoints

### Authentication
- `GET /sign_in` - Sign in form
- `POST /sign_in` - Create session
- `DELETE /sign_out` - Destroy session
- `GET /sign_up` - Registration form
- `POST /sign_up` - Create account

### Boards
- `GET /boards` - List all boards
- `GET /boards/:id` - Show board (Kanban view)
- `GET /boards/new` - New board form
- `POST /boards` - Create board
- `GET /boards/:id/edit` - Edit board form
- `PATCH /boards/:id` - Update board
- `DELETE /boards/:id` - Delete board

### Columns
- `POST /boards/:board_id/columns` - Create column
- `PATCH /boards/:board_id/columns/:id` - Update column
- `DELETE /boards/:board_id/columns/:id` - Delete column
- `PATCH /boards/:board_id/columns/:id/move` - Move column

### Cards
- `POST /boards/:board_id/columns/:column_id/cards` - Create card
- `PATCH /boards/:board_id/columns/:column_id/cards/:id` - Update card
- `DELETE /boards/:board_id/columns/:column_id/cards/:id` - Delete card
- `PATCH /boards/:board_id/columns/:column_id/cards/:id/move` - Move card

## License

MIT
