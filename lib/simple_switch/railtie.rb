require 'simple_switch'
require 'rails'

module SimpleSwitch
  class Railtie < Rails::Railtie
    railtie_name :simple_switch

    rake_tasks do
      load 'tasks/simple_switch.rake'
    end
  end
end