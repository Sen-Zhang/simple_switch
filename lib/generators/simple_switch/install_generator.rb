require 'rails/generators/base'

module SimpleSwitch
  module Generators

    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Copy required files for each strategy'

      def copy_files
        case SimpleSwitch.feature_store
        when :database
          # Copy the migration file to db/migrate.
          copy_file 'migration.rb',
                    "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_create_simple_switch_tables.simple_switch.rb"
        when :yml
          # Copy feature configuration sample file feature_config_sample.yml to customized location.
          copy_file 'feature_config_sample.yml',
                    "#{SimpleSwitch.feature_config_file_dir}/#{SimpleSwitch.feature_config_file_name}"
        else
        end
      end
    end

  end
end
