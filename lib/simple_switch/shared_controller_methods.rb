module SimpleSwitch
  module SharedControllerMethods

    def feature_config_info
      SimpleSwitch.feature_manager.feature_config
    end

    def turn_on(feature, env)
      SimpleSwitch.feature_manager.turn_on(feature, env)
    end

    def turn_off(feature, env)
      SimpleSwitch.feature_manager.turn_off(feature, env)
    end

  end
end
