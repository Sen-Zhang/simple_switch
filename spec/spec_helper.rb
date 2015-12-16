ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../spec/dummy/config/environment', __FILE__)
require 'route_helper'
require 'rspec/rails'
require 'shoulda-matchers'
require 'factory_girl_rails'

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

RSpec.configure do |config|
  config.fixture_path               = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.order                      = :random

  config.include RouteHelper, type: :routing
  config.include RouteHelper, type: :controller
end
