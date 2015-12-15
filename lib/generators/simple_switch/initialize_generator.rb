require 'rails/generators/base'

module SimpleSwitch
  module Generators

    class InitializeGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Copy initializer file simple_switch.rb to config/initializers.'

      def copy_initializer
        copy_file 'simple_switch.rb', 'config/initializers/simple_switch.rb'
      end
    end

  end
end
