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

    def has_feature?(feature)
      SimpleSwitch::Feature.find_by_name(feature).present?
    end

    def add_feature(options)
      feature = SimpleSwitch::Feature.find_or_create_by(name: options[:name])
      feature.update(description: options[:description])

      reload_config!
    end

    def has_environment?(environment)
      SimpleSwitch::Environment.find_by_name(environment).present?
    end

    def add_environment(options)
      SimpleSwitch::Environment.find_or_create_by(name: options[:name])

      reload_config!
    end

    def add_state(options)
      feature     = SimpleSwitch::Feature.find_by_name(options[:feature])
      environment = SimpleSwitch::Environment.find_by_name(options[:environment])

      feature.states.create(status: options[:status], environment: environment)
      reload_config!
    end

    def update(feature, env, value)
      states(feature)[env][0] = value if valid_feature_name_for_env?(feature, env)

      SimpleSwitch::State.update(states(feature)[env][1], status: value)
    end

    def delete(feature)
      feature_config.delete(feature) if valid_feature_name?(feature)

      SimpleSwitch::Feature.find_by_name(feature).destroy
    end

    private

    def load_config
      features = SimpleSwitch::Feature.includes([:states, :environments]).all

      HashWithIndifferentAccess.new(
        features.inject({}) do |hash, f|
          hash.merge(
            f.name => {
              description: f.description,
              states:      f.states.inject({}) { |h, s| h.merge(s.environment.name => [s.status, s.id]) }
            })
        end
      )
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
