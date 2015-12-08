# Simple Switch

Simple Feature Switch Engine

[![Code Climate](https://codeclimate.com/github/Sen-Zhang/simple_switch/badges/gpa.svg)](https://codeclimate.com/github/Sen-Zhang/simple_switch)


## Requirement
* Ruby 2.0+
* Rails 3.0+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'simple_switch'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_switch

## Usage

### Basic

Run install generator:

    $ rails generate simple_switch:install

A initializer file named `simple_switch.rb` will be added into `config/initializers` after running
install generator. In that file, you can customize the feature configuration yaml file's name and
installation place.

      # feature switch configuration yaml file stored location, by default it is stored
      # under config directory
      config.feature_config_file_dir  = 'config'

      # feature switch configuration yaml file name, by default it is 'feature_config.yml'
      config.feature_config_file_name = 'feature_config.yml'

Then run the following commands to copy feature configuration yaml file to the target directory.

Run install generator:

    $ rails generate simple_switch:install_yaml

Now you are ready to define features:

    foo:
        development: true
        test: true
        production: false

    bar:
        development: false
        test: true
        production: false

Now you can use it in models like this:

    class TestModel < ActiveRecord::Base
      ...

      if feature_on?(:foo)
        def foo_method
          ...
        end
      end

      def bar_method
        if feature_on?(:bar)
          ...
        end
      end

      ...
    end

In controllers like this:

    class TestController < ApplicationController
      ...

      def index
        ...

        if feature_on?(:foo)
          redirect_to :back
        end

        ...
      end

      ...
    end

And in views like this:

    <% if feature_on?(:foo) %>
        <p>Experiment foo is on</p>
    <% end %>

    <% if feature_off?(:bar) %>
        <p>Experiment bar is off</p>
    <% end %>

### Toggle Features

The following methods are only accessible in controllers:

`feature_config_info` return a hash represents the current feature configuration condition.

`turn_on(feature, env)` turn on a feature on a indicated environment.

    turn_on(:foo, :development)

`turn_off(feature, env)` turn off a feature on a indicated environment.

    turn_off(:foo, :development)
