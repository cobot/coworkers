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
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
end

Coworkers::Conf = OpenStruct.new app_id: '11bdfe6d6478d250cf90016532daebea',
  app_secret: '994f4ccfb06eb92f2742067bd6b310f43e5d740e0f8bc7c35dcbed0e8102c0b0',
  app_site: 'https://www.cobot.me'
