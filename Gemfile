source 'https://rubygems.org'

ruby '2.2.2'

gem 'rails', '~>4.2.5'
gem 'pg'
gem 'omniauth'
gem 'omniauth_cobot', '~>0.0.3'

gem 'simple_form'
gem 'sentry-raven'
gem 'param_protected'
gem 'redcarpet'
gem 'tzinfo'
gem 'rinku', require: 'rails_rinku'
gem 'virtus'
gem 'cobot_client', '~>0.6.0'
gem 'jquery-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'compass-rails'
  gem 'uglifier'
end

group :development do
  gem 'rspec-rails', '~> 3.2.0'
  gem 'dotenv-rails'
  gem 'sass-rails'
  gem 'compass-rails'
end

group :production do
  gem 'puma'
  gem 'rails_12factor'
end

group :test do
  gem 'rspec-rails', '~> 3.2.0'
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'webmock'
  gem 'timecop'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'test-unit'
end
