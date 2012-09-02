Coworkers::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

Coworkers::Conf = OpenStruct.new app_id: '99ebdfa4f76b087ad0059317c5714160',
  app_secret: 'a58f9cf395eaa8bff240004eed7d8b88845e77a002bb22402e55f379b5a8896b',
  app_site: 'http://www.smackaho.st:3000'
