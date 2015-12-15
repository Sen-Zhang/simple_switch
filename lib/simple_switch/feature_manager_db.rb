module SimpleSwitch
  class FeatureManagerDb
    include SimpleSwitch::ManagerSharedMethods
    attr_reader :feature_config

    def initialize
      @feature_config = load_config
    end

    def self.instance
      return @@instance ||= send(:new)
    end

    private_class_method :new

    def update(feature, env, value)
      @feature_config[feature][env] = value if valid_feature_name_for_env?(feature, env)

      # TODO: update
    end

    def delete(feature)
      @feature_config.delete(feature) if valid_feature_name?(feature)

      # TODO: delete
    end

    private

    def load_config
      features = SimpleSwitch::Feature.includes([:states, :environments]).all

      HashWithIndifferentAccess.new(features.inject({}) do |hash, f|
        hash.merge(f.name => f.states.inject({}) { |h, s| h.merge(s.environment.name => s.status) })
      end)
    end

    def valid_feature_name_with_message?(feature)
      return true if valid_feature_name_without_message?(feature)

      raise "Cannot find feature '#{feature}', check out your database."
    end

    def valid_feature_name_for_env_with_message?(feature, env=Rails.env)
      return true if valid_feature_name_for_env_without_message?(feature, env)

      raise "Cannot find environment '#{env}' for feature '#{feature}', check out your database."
    end

    alias_method_chain :valid_feature_name?, :message
    alias_method_chain :valid_feature_name_for_env?, :message
  end
end
