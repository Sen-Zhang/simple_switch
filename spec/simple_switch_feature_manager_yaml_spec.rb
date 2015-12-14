require 'spec_helper'

describe 'SimpleSwitchFeatureManagerYaml' do
  describe 'FeatureManagerYaml' do
    before(:each) { reset_yaml }

    it 'feature_config returns the correct configuration' do
      expected_config = HashWithIndifferentAccess.new({
        foo: {
          development: true,
          test:        true,
          production:  false
        },
        bar: {
          development: true,
          test:        false,
          production:  true
        }
      })

      expect(SimpleSwitch.feature_manager.feature_config).to eq(expected_config)
    end

    it 'on? works fine' do
      allow(Rails).to receive(:env).and_return('development')

      expect(SimpleSwitch.feature_manager.on?(:foo)).to be_truthy
      expect(SimpleSwitch.feature_manager.on?(:bar)).to be_truthy

      allow(Rails).to receive(:env).and_return('test')

      expect(SimpleSwitch.feature_manager.on?(:foo)).to be_truthy
      expect(SimpleSwitch.feature_manager.on?(:bar)).to be_falsey

      allow(Rails).to receive(:env).and_return('production')

      expect(SimpleSwitch.feature_manager.on?(:foo)).to be_falsey
      expect(SimpleSwitch.feature_manager.on?(:bar)).to be_truthy

      expect(SimpleSwitch.feature_manager.on?(:foo, :development)).to be_truthy
      expect(SimpleSwitch.feature_manager.on?(:bar, :development)).to be_truthy

      expect(SimpleSwitch.feature_manager.on?(:foo, :test)).to be_truthy
      expect(SimpleSwitch.feature_manager.on?(:bar, :test)).to be_falsey

      expect(SimpleSwitch.feature_manager.on?(:foo, :production)).to be_falsey
      expect(SimpleSwitch.feature_manager.on?(:bar, :production)).to be_truthy
    end

    it 'off? works fine' do
      allow(Rails).to receive(:env).and_return('development')

      expect(SimpleSwitch.feature_manager.off?(:foo)).to be_falsey
      expect(SimpleSwitch.feature_manager.off?(:bar)).to be_falsey

      allow(Rails).to receive(:env).and_return('test')

      expect(SimpleSwitch.feature_manager.off?(:foo)).to be_falsey
      expect(SimpleSwitch.feature_manager.off?(:bar)).to be_truthy

      allow(Rails).to receive(:env).and_return('production')

      expect(SimpleSwitch.feature_manager.off?(:foo)).to be_truthy
      expect(SimpleSwitch.feature_manager.off?(:bar)).to be_falsey

      expect(SimpleSwitch.feature_manager.off?(:foo, :development)).to be_falsey
      expect(SimpleSwitch.feature_manager.off?(:bar, :development)).to be_falsey

      expect(SimpleSwitch.feature_manager.off?(:foo, :test)).to be_falsey
      expect(SimpleSwitch.feature_manager.off?(:bar, :test)).to be_truthy

      expect(SimpleSwitch.feature_manager.off?(:foo, :production)).to be_truthy
      expect(SimpleSwitch.feature_manager.off?(:bar, :production)).to be_falsey
    end

    it 'update works fine' do
      expect(SimpleSwitch.feature_manager.on?(:foo, :development)).to be_truthy

      SimpleSwitch.feature_manager.update(:foo, :development, false)

      expect(SimpleSwitch.feature_manager.off?(:foo, :development)).to be_truthy

      expect(SimpleSwitch.feature_manager.off?(:bar, :test)).to be_truthy

      SimpleSwitch.feature_manager.update(:bar, :test, true)

      expect(SimpleSwitch.feature_manager.on?(:bar, :test)).to be_truthy
    end

    it 'delete works fine' do
      expect(SimpleSwitch.feature_manager.on?(:foo, :development)).to be_truthy

      SimpleSwitch.feature_manager.delete(:foo)

      expect {
        SimpleSwitch.feature_manager.on?(:foo, :development)
      }.to raise_error(RuntimeError, "Cannot find feature 'foo', check out your feature_config.yml file.")
    end

    it 'raise errors correctly' do
      expect {
        SimpleSwitch.feature_manager.update(:foobar, :development, false)
      }.to raise_error(RuntimeError, "Cannot find feature 'foobar', check out your feature_config.yml file.")

      expect {
        SimpleSwitch.feature_manager.update(:foo, :dev, false)
      }.to raise_error(RuntimeError, "Cannot find environment 'dev' for feature 'foo', check out your feature_config.yml file.")
    end
  end

  private
  def reset_yaml
    # reset feature_config.yml
    File.open('spec/config/feature_config.yml', 'w') do |f|
      init_hash = HashWithIndifferentAccess.new(
        {
          foo: {
            development: true,
            test:        true,
            production:  false
          },
          bar: {
            development: true,
            test:        false,
            production:  true
          }
        }
      )

      f.puts init_hash.to_hash.to_yaml
    end

    allow_any_instance_of(SimpleSwitch::FeatureManagerYaml).to receive(:file_path).and_return('spec/config/feature_config.yml')
    allow(SimpleSwitch).to receive(:feature_store).and_return(:yml)
    SimpleSwitch.feature_manager.send(:reload_config!)
  end
end
