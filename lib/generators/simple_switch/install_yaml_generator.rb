require 'rails/generators/base'

module SimpleSwitch
  module Generators

    class InstallYamlGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Copy feature configuration sample file feature_config_sample.yml to your application.'

      def copy_initializer
        copy_file 'feature_config_sample.yml',
                  "#{SimpleSwitch.feature_config_file_dir}/#{SimpleSwitch.feature_config_file_name}"
      end
    end

  end
end
