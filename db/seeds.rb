# Create a demo user
demo_user = User.find_or_create_by!(email: "demo@example.com") do |user|
  user.name = "Demo User"
  user.password = "password123"
end

puts "Created demo user: #{demo_user.email}"

# Create a sample board with cards
if demo_user.boards.empty?
  board = demo_user.boards.create!(
    title: "Product Launch",
    description: "Tasks for the upcoming product launch"
  )

  # Get the default columns
  todo_column = board.columns.find_by(name: "To Do")
  in_progress_column = board.columns.find_by(name: "In Progress")
  done_column = board.columns.find_by(name: "Done")

  # Add some cards to To Do
  todo_column.cards.create!([
    { title: "Write marketing copy", description: "Create compelling copy for the landing page", priority: :high, due_date: 5.days.from_now },
    { title: "Design social media assets", priority: :medium, due_date: 7.days.from_now },
    { title: "Set up email campaign", description: "Configure automated email sequences", priority: :medium },
    { title: "Review pricing strategy", priority: :low }
  ])

  # Add some cards to In Progress
  in_progress_column.cards.create!([
    { title: "Build landing page", description: "Implement the new landing page design", priority: :high, due_date: 3.days.from_now },
    { title: "Test payment integration", priority: :high, due_date: 2.days.from_now }
  ])

  # Add some cards to Done
  done_column.cards.create!([
    { title: "Finalize product features", priority: :high },
    { title: "Create brand guidelines", priority: :medium }
  ])

  puts "Created sample board: #{board.title}"

  # Create another board
  board2 = demo_user.boards.create!(
    title: "Personal Tasks",
    description: "Personal to-do items"
  )

  puts "Created sample board: #{board2.title}"
end

puts "Seed data created successfully!"
puts "You can sign in with:"
puts "  Email: demo@example.com"
puts "  Password: password123"
