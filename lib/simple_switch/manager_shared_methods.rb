module SimpleSwitch
  module ManagerSharedMethods

    def on?(feature, env=Rails.env)
      reload_config! if env == 'development'

      begin
        if valid_feature_name_for_env?(feature, env)
          config = states(feature)[env]

          config.is_a?(Array) ? config[0] : config
        end
      rescue
        true
      end
    end

    def off?(feature, env=Rails.env)
      !on?(feature, env)
    end

    def turn_on(feature, env)
      update(feature, env, true)
    end

    def turn_off(feature, env)
      update(feature, env, false)
    end

    private
    def reload_config!
      @feature_config = load_config
    end

    def states(feature)
      feature_config[feature][:states]
    end

    def valid_feature_name?(feature)
      reload_config! unless feature_config.has_key?(feature)

      feature_config.has_key?(feature)
    end

    def valid_feature_name_for_env?(feature, env)
      valid_feature_name?(feature)

      states(feature).has_key?(env)
    end

  end
end