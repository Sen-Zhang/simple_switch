module SimpleSwitch
  class FeatureManager
    class << self
      @@managers = HashWithIndifferentAccess.new

      def get_manager(strategy)
        @@managers = initialize_managers if @@managers.empty?
        @@managers[strategy]
      end

      def initialize_managers
        @@managers.merge!(database: FeatureManagerDb.instance,
                          yml:      FeatureManagerYaml.instance)
      end
    end
  end
end
