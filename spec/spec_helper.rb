ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../spec/dummy/config/environment', __FILE__)
require 'route_helper'
require 'rspec/rails'
require 'shoulda-matchers'
require 'database_cleaner'
require 'factory_girl_rails'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.order                      = :random

  config.include RouteHelper, type: :routing
  config.include RouteHelper, type: :controller

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
    Rails.application.load_seed
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
