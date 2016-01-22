namespace :books do
  task :setup, [:name, :admin_email] => :environment do |t, args|
    book = Book.create! name: args[:name], contact_email: args[:admin_email]
    book.switch!

    password = Devise.friendly_token.first(10)
    AdminUser.create! email: args[:admin_email], password: password, password_confirmation: password

    puts "Congrats. A new book has been created. Please enter to admin panel with generated password #{password}"
  end
end