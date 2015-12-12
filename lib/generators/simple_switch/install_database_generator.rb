require 'rails/generators/base'

module SimpleSwitch
  module Generators

    class InstallDatabaseGenerator < Rails::Generators::Base
      source_root File.expand_path('../../templates', __FILE__)

      desc 'Copy the migration file to db/migrate.'

      def copy_migration
        copy_file 'migration.rb',
                  "db/migrate/#{Time.now.utc.strftime('%Y%m%d%H%M%S')}_create_simple_switch_tables.simple_switch.rb"
      end
    end

  end
end
