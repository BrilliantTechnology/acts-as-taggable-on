RSpec.configure do |config|

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end

  # Specs that need to see records committed by other threads/connections.
  # After hooks run in reverse order, so the reset below runs after the
  # DatabaseCleaner.clean defined further down.
  config.before(:each, :database_cleaner_delete) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, :database_cleaner_delete) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

end
