# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
require 'couch_potato/rspec'
require 'capybara/rspec'
Dir[Rails.root.join('features', 'support', '*_helpers.rb')].each {|f| require f}
require Rails.root.join('features', 'support', 'id_generators')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  config.include CobotApiHelpers
  config.include SessionHelpers
  config.include SpaceHelpers
  config.include IdGenerators
  config.mock_with :rspec

  config.before(:each) do
    WebMock.stub_request(:post, "https://www.cobot.me/oauth2/access_token").to_return(body: {access_token: '1'}.to_json, headers: {'Content-Type' => 'application/json'})
  end
end

def log_in(user)
  controller.stub(:current_user) {user}
end

WebMock.disable_net_connect!(allow_localhost: true)
DB = CouchPotato.database
