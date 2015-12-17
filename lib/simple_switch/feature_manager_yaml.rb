module SimpleSwitch
  class FeatureManagerYaml
    include SimpleSwitch::ManagerSharedMethods
    attr_reader :feature_config, :file_dir, :file_name

    def initialize
      @file_dir       = SimpleSwitch.feature_config_file_dir
      @file_name      = SimpleSwitch.feature_config_file_name
      @feature_config = load_config
    end

    def self.instance
      return @@instance ||= send(:new)
    end

    private_class_method :new

    def update(feature, env, value)
      states(feature)[env] = value if valid_feature_name_for_env?(feature, env)

      save_to_yaml
    end

    def delete(feature)
      feature_config.delete(feature) if valid_feature_name?(feature)

      save_to_yaml
    end

    private

    def file_path
      Rails.root.join(file_dir, file_name)
    end

    def load_config
      HashWithIndifferentAccess.new(YAML::load(File.open(file_path)))
    end

    def save_to_yaml
      begin
        File.open(file_path, 'w') do |f|
          f.puts @feature_config.to_hash.to_yaml
        end

        true
      rescue
        false
      end
    end

    def valid_feature_name_with_message?(feature)
      return true if valid_feature_name_without_message?(feature)

      raise "Cannot find feature '#{feature}', check out your #{file_name} file."
    end

    def valid_feature_name_for_env_with_message?(feature, env=Rails.env)
      return true if valid_feature_name_for_env_without_message?(feature, env)

      raise "Cannot find environment '#{env}' for feature '#{feature}', "\
            "check out your #{file_name} file."
    end

    alias_method_chain :valid_feature_name?, :message
    alias_method_chain :valid_feature_name_for_env?, :message
  end
end
