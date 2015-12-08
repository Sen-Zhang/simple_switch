module SimpleSwitch
  module SharedControllerMethods

    def feature_config_info
      SimpleSwitch.feature_manager.feature_config
    end

    def turn_on(feature, env)
      SimpleSwitch.feature_manager.update(feature, env, true)
    end

    def turn_off(feature, env)
      SimpleSwitch.feature_manager.update(feature, env, false)
    end

  end
end
