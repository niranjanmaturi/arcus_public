require 'io/console'

desc 'This resets the password for the user.'
task :reset_admin => :environment do
  if ARGV[1].blank?
    puts "Provide the email address you want to reset the password for:"
    puts ''
    puts '  Ex. - rake reset_admin {email to reset}'
    exit 1
  end

  ActiveRecord::Base.logger.level = 1

  user = AdminUser.search_by_email(ARGV[1]).first
  unless user
    puts 'Error: Invalid user.'
    exit 1
  end

  puts 'Please enter the new password'
  user.password = $stdin.noecho(&:gets).chomp
  puts 'Please re-enter the new password'
  user.password_confirmation = $stdin.noecho(&:gets).chomp

  if user.password != user.password_confirmation
    puts 'Error: Passwords must be the same.'
    exit 1
  end

  if user.save
    puts "Password for #{user.email} changed."
    exit 0
  else
    user.errors.full_messages.each { |msg| puts "Error: #{msg}" }
    exit 1
  end
end
