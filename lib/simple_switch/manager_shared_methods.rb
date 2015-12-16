module SimpleSwitch
  module ManagerSharedMethods

    def on?(feature, env=Rails.env)
      reload_config! if Rails.env == 'development'

      if valid_feature_name_for_env?(feature, env)
        config = feature_config[feature][env]

        config.is_a?(Array) ? config[0] : config
      end
    end

    def off?(feature, env=Rails.env)
      !on?(feature, env)
    end

    private
    def reload_config!
      @feature_config = load_config
    end

    def valid_feature_name?(feature)
      reload_config! unless feature_config.has_key?(feature)

      feature_config.has_key?(feature)
    end

    def valid_feature_name_for_env?(feature, env)
      valid_feature_name?(feature)

      feature_config[feature].has_key?(env)
    end

  end
end