require 'simple_switch/version'

module SimpleSwitch
  mattr_accessor :feature_config_file_dir
  @@feature_config_file_name = 'config'

  mattr_accessor :feature_config_file_name
  @@feature_config_file_name = 'feature_config.yml'

  def self.setup
    yield self
  end

  def self.feature_manager
    SimpleSwitch::Switch.instance
  end

  class Engine < ::Rails::Engine
  end
end

require 'simple_switch/switch'
require 'simple_switch/shared_methods'
require 'simple_switch/shared_controller_methods'
require 'simple_switch/action_controller/base'
require 'simple_switch/active_record/base'
