require 'bundler/setup'
require 'rails'
require 'simple_switch'

Bundler.setup

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.order = :random

  config.before :each do
    # reset feature_config.yml
    File.open('spec/config/feature_config.yml', 'w') do |f|
      init_hash = HashWithIndifferentAccess.new(
        {
          foo: {
            development: true,
            test:        true,
            production:  false
          },
          bar: {
            development: true,
            test:        false,
            production:  true
          }
        }
      )

      f.puts init_hash.to_hash.to_yaml
    end

    allow_any_instance_of(SimpleSwitch::Switch).to receive(:file_path).and_return('spec/config/feature_config.yml')
    SimpleSwitch.feature_manager.send(:reload_config!)
  end
end
