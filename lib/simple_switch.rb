require 'simple_switch/engine'

module SimpleSwitch
  mattr_accessor :feature_store
  @@feature_store = :database

  mattr_accessor :feature_config_file_dir
  @@feature_config_file_name = 'config'

  mattr_accessor :feature_config_file_name
  @@feature_config_file_name = 'feature_config.yml'

  def self.setup
    yield self
  end

  def self.feature_manager
    SimpleSwitch::FeatureManager.get_manager
  end
end

# TODO: is the following still in need?
require 'simple_switch/manager_shared_methods'
require 'simple_switch/feature_manager_db'
require 'simple_switch/feature_manager_yaml'
require 'simple_switch/feature_manager'
require 'simple_switch/shared_methods'
require 'simple_switch/shared_controller_methods'
require 'simple_switch/action_controller/base'
require 'simple_switch/active_record/base'
