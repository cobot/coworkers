# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'
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
  config.include CobotHelpers
  config.include IdGenerators
  config.include MembershipHelpers
  config.mock_with :rspec

  config.before(:each) do
    WebMock.stub_request(:post, /subscriptions/).to_return(body: '{}')
    WebMock.stub_request(:post, 'https://www.cobot.me/oauth2/access_token').to_return(body: {access_token: '1'}.to_json, headers: {'Content-Type' => 'application/json'})
    WebMock.stub_request(:post, 'https://www.cobot.me/api/access_tokens/test_token/space')
           .with(body: {space_id: 'co-up'},
             headers: {'Authorization' => 'Bearer test_token'})
           .to_return(body: {token: 'test_space_token_co-up'}.to_json)
  end
end

def log_in(user)
  allow(controller).to receive(:current_user) { user }
end

WebMock.disable_net_connect!(allow_localhost: true)
