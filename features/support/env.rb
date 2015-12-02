require 'cucumber/rails'

require 'capybara'
Capybara.default_selector = :css

ActionController::Base.allow_rescue = false

begin
  DatabaseCleaner.strategy = :truncation

  Before do
    DatabaseCleaner.clean!
  end
rescue NameError
  raise "You need to add database_cleaner to your Gemfile (in the :test group) if you wish to use it."
end
