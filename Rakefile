require './app'
require 'inquirer'

namespace :db do
  task :migrate do
    DataMapper.auto_upgrade!
  end
  task :hard_migrate do
    DataMapper.auto_migrate!
  end
end

namespace :users do
  task :list do
    users = User.find
    users.each do |user|
      puts user.attributes
    end
  end

  task :delete, [:id] do |t, args|
    user = User.get(args.id)
    if user && user.destroy
      puts "Deleted user"
    else
      puts "Failed to delete"
    end

  end

  task :create do |t, args|
    user = User.new
    user.username = Ask.input "Username"
    user.password = Ask.input("Password", password: true)
    user.name     = Ask.input "Name"
    user.email    = Ask.input "Email"
    user.roles    = [User::ROLES[Ask.list("Role", User::ROLES)]]

    if user.save
      puts "Created user:"
      puts user.attributes
    else
      puts "Failed to create: "
      puts user.errors.full_messages.join("\n")
    end
  end

  task :update_password do |t, args|
    username = Ask.input "Username"
    user = User.first(username: username)
    user.password = Ask.input("Password", password: true)

    if user.save
      puts "updated user:"
      puts user.attributes
    else
      puts "Failed to update: "
      puts user.errors.full_messages.join("\n")
    end
  end
end
