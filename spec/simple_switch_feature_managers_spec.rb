require 'spec_helper'

describe 'SimpleSwitchFeatureManagers' do
  describe 'FeatureManagerDb' do
    before(:each) { test_reset_db }

    it 'feature_config returns the correct configuration' do
      expected_config = HashWithIndifferentAccess.new({
        foo: {
          development: [true, 1],
          test:        [true, 2],
          production:  [false, 3]
        },
        bar: {
          development: [true, 4],
          test:        [false, 5],
          production:  [true, 6]
        }
      })

      assert_feature_config_works_fine(expected_config)
    end

    it 'on? works fine' do
      assert_on_works_fine
    end

    it 'off? works fine' do
      assert_off_works_fine
    end

    it 'update works fine' do
      assert_update_works_fine
    end

    it 'delete works fine' do
      error_msg = "Cannot find feature 'foo', check out your database."
      assert_delete_works_fine(error_msg)
    end

    it 'raise errors correctly' do
      error_msg_1 = "Cannot find feature 'foobar', check out your database."
      error_msg_2 = "Cannot find environment 'dev' for feature 'foo', check out your database."

      assert_raise_errors_correctly(error_msg_1, error_msg_2)
    end
  end

  describe 'FeatureManagerYaml' do
    before(:each) { test_reset_yaml }

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

      assert_feature_config_works_fine(expected_config)
    end

    it 'on? works fine' do
      assert_on_works_fine
    end

    it 'off? works fine' do
      assert_off_works_fine
    end

    it 'update works fine' do
      assert_update_works_fine
    end

    it 'delete works fine' do
      error_msg = "Cannot find feature 'foo', check out your feature_config.yml file."
      assert_delete_works_fine(error_msg)
    end

    it 'raise errors correctly' do
      error_msg_1 = "Cannot find feature 'foobar', check out your feature_config.yml file."
      error_msg_2 = "Cannot find environment 'dev' for feature 'foo', check out your feature_config.yml file."

      assert_raise_errors_correctly(error_msg_1, error_msg_2)
    end
  end

  private

  def test_reset_db
    allow(SimpleSwitch).to receive(:feature_store).and_return(:database)
    SimpleSwitch.feature_manager.send(:reload_config!)
  end

  def test_reset_yaml
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

  def assert_feature_config_works_fine(expected_config)
    expect(SimpleSwitch.feature_manager.feature_config).to eq(expected_config)
  end

  def assert_on_works_fine
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

  def assert_off_works_fine
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

  def assert_update_works_fine
    expect(SimpleSwitch.feature_manager.on?(:foo, :development)).to be_truthy

    SimpleSwitch.feature_manager.update(:foo, :development, false)

    expect(SimpleSwitch.feature_manager.off?(:foo, :development)).to be_truthy

    expect(SimpleSwitch.feature_manager.off?(:bar, :test)).to be_truthy

    SimpleSwitch.feature_manager.update(:bar, :test, true)

    expect(SimpleSwitch.feature_manager.on?(:bar, :test)).to be_truthy
  end

  def assert_delete_works_fine(err_msg)
    expect(SimpleSwitch.feature_manager.on?(:foo, :development)).to be_truthy

    SimpleSwitch.feature_manager.delete(:foo)

    expect {
      SimpleSwitch.feature_manager.on?(:foo, :development)
    }.to raise_error(RuntimeError, err_msg)
  end

  def assert_raise_errors_correctly(err_msg_1, err_msg_2)
    expect {
      SimpleSwitch.feature_manager.update(:foobar, :development, false)
    }.to raise_error(RuntimeError, err_msg_1)

    expect {
      SimpleSwitch.feature_manager.update(:foo, :dev, false)
    }.to raise_error(RuntimeError, err_msg_2)
  end
end
