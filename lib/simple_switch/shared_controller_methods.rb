module SimpleSwitch
  module SharedControllerMethods

    def feature_config_info
      SimpleSwitch.feature_manager.feature_config
    end

    def update_feature(feature, env, new_value)
      SimpleSwitch.feature_manager.update(feature, env, new_value)
    end

  end
end
