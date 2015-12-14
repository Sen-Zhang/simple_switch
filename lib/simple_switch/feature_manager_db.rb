module SimpleSwitch
  class FeatureManagerDb
    def initialize
    end

    def self.instance
      return @@instance ||= send(:new)
    end

    private_class_method :new
  end
end
