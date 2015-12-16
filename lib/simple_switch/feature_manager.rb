module SimpleSwitch
  class FeatureManager
    class << self
      def get_manager
        case SimpleSwitch.feature_store
        when :database
          FeatureManagerDb.instance
        when :yml
          FeatureManagerYaml.instance
        else
        end
      end
    end
  end
end
