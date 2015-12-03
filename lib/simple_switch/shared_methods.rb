module SimpleSwitch
  module SharedMethods

    def feature_on?(feature)
      SimpleSwitch.feature_manager.on?(feature)
    end

    def feature_off?(feature)
      !feature_on?(feature)
    end

  end
end
