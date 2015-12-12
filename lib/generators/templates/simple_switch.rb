SimpleSwitch.setup do |config|

  # feature management strategy
  # the supported strategies are: [:yml, :database]
  # default strategy is [:database]
  config.feature_store = :database

  # configuration for yml strategy
  # feature switch configuration yaml file stored location, by default it is stored
  # under config directory
  # config.feature_config_file_dir  = 'config'

  # configuration for yml strategy
  # feature switch configuration yaml file name, by default it is 'feature_config.yml'
  # config.feature_config_file_name = 'feature_config.yml'

end
