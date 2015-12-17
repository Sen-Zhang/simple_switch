namespace :simple_switch do

  # eg: bundle exec rake simple_switch:add_feature name='Foo' description='Foo feature'
  desc 'Add a feature'
  task :add_feature => :environment do
    check_strategy

    name            = ENV['name']
    description     = ENV['description']
    feature_manager = SimpleSwitch.feature_manager

    abort 'Feature name is required.' if name.blank?
    abort "Feature #{name} already exists." if feature_manager.has_feature?(name)

    feature_manager.add_feature(name: name, description: description)
    abort "Feature #{name} added."
  end

  # eg: bundle exec rake simple_switch:add_environment name='test'
  desc 'Add an environment'
  task :add_environment => :environment do
    check_strategy

    name            = ENV['name']
    feature_manager = SimpleSwitch.feature_manager

    abort 'Environment name is required.' if name.blank?
    abort "Environment #{name} already exists." if feature_manager.has_environment?(name)

    feature_manager.add_environment(name: name)
    abort "Environment #{name} added."
  end

  # eg: bundle exec rake simple_switch:add_feature_config feature='foo' environment='test' status=true
  desc 'Add feature configuration'
  task :add_feature_config => :environment do
    check_strategy

    feature     = ENV['feature']
    environment = ENV['environment']
    status      = ENV['status']

    feature_manager = SimpleSwitch.feature_manager

    abort 'Feature name is required.' if feature.blank?
    abort "Feature #{feature} does not exist, add this feature first." unless feature_manager.has_feature?(feature)
    abort 'Environment name is required.' if environment.blank?
    abort "Environment #{environment} does not exist, add this environment first." unless feature_manager.has_environment?(environment)

    feature_manager.add_state(feature: feature, environment: environment, status: status)

    abort 'Feature configuration added.'
  end

  # eg: bundle exec rake simple_switch:turn_on feature='foo' environment='test'
  desc 'Turn on feature for an environment'
  task :turn_on => :environment do
    check_strategy

    feature     = ENV['feature']
    environment = ENV['environment']

    feature_manager = SimpleSwitch.feature_manager

    abort 'Feature name is required.' if feature.blank?
    abort "Feature #{feature} does not exist." unless feature_manager.has_feature?(feature)
    abort 'Environment name is required.' if environment.blank?
    abort "Environment #{environment} does not exist, add this environment first." unless feature_manager.has_environment?(environment)

    begin
      feature_manager.turn_on(feature, environment)
      abort "Feature '#{feature}' has been turned on for environment '#{environment}'."
    rescue
      abort "Feature '#{feature}' is not configured on environment '#{environment}'."
    end
  end

  # eg: bundle exec rake simple_switch:turn_off feature='foo' environment='test'
  desc 'Turn off feature for an environment'
  task :turn_off => :environment do
    check_strategy

    feature     = ENV['feature']
    environment = ENV['environment']

    feature_manager = SimpleSwitch.feature_manager

    abort 'Feature name is required.' if feature.blank?
    abort "Feature #{feature} does not exist." unless feature_manager.has_feature?(feature)
    abort 'Environment name is required.' if environment.blank?
    abort "Environment #{environment} does not exist, add this environment first." unless feature_manager.has_environment?(environment)

    begin
      feature_manager.turn_off(feature, environment)
      abort "Feature '#{feature}' has been turned off for environment '#{environment}'."
    rescue
      abort "Feature '#{feature}' is not configured on environment '#{environment}'."
    end
  end

  private
  def check_strategy
    # TODO: Temporarily disable rake tasks for yml strategy
    abort "'yml' strategy does not support this task, please modify feature"\
          ' configuration yaml file instead.' if SimpleSwitch.feature_store != :database
  end
end