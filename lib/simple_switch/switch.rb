module SimpleSwitch
  class Switch
    attr_reader :feature_config

    def initialize
      @feature_config = load_config
    end

    def self.instance
      return @@instance ||= send(:new)
    end

    private_class_method :new

    def on?(feature, env=Rails.env)
      reload_config! if Rails.env.development?

      @feature_config[feature][env] if valid_feature_name_for_env?(feature, env)
    end

    def off?(feature, env=Rails.env)
      !on?(feature, env)
    end

    def update(feature, env, value)
      @feature_config[feature][env] = value if valid_feature_name_for_env?(feature, env)

      save_to_yaml
    end

    def delete(feature)
      @feature_config.delete(feature) if valid_feature_name?(feature)

      save_to_yaml
    end

    private

    def file_path
      Rails.root.join(SimpleSwitch::feature_config_file_dir, SimpleSwitch::feature_config_file_name)
    end

    def load_config
      HashWithIndifferentAccess.new(YAML::load(File.open(file_path)))
    end

    def reload_config!
      @feature_config = load_config
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

    def valid_feature_name?(feature)
      reload_config! unless @feature_config.has_key?(feature)

      return true if @feature_config.has_key?(feature)

      raise "Cannot find feature '#{feature}', check out your "\
            "#{SimpleSwitch::feature_config_file_name} file."
    end

    def valid_feature_name_for_env?(feature, env=Rails.env)
      valid_feature_name?(feature)

      return true if @feature_config[feature].has_key?(env)

      raise "Cannot find environment '#{env}' for feature '#{feature}', "\
            "check out your #{SimpleSwitch::feature_config_file_name} file."
    end
  end
end
