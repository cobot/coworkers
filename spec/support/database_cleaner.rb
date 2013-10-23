RSpec.configure do |config|
  config.before(:each) do
    DatabaseCleaner.clean_with(:truncation)
  end
end
