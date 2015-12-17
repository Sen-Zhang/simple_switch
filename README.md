# Simple Switch

Simple Feature Switch Engine

[![Code Climate](https://codeclimate.com/github/Sen-Zhang/simple_switch/badges/gpa.svg)](https://codeclimate.com/github/Sen-Zhang/simple_switch)
[![Build Status](https://travis-ci.org/Sen-Zhang/simple_switch.svg?branch=master)](https://travis-ci.org/Sen-Zhang/simple_switch)


## Requirement
* Ruby 2.0+
* Rails 4.0+

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

### YML Strategy
Store and manage features and configurations all in a single yaml file.

Run initialize generator:

    $ rails generate simple_switch:initialize

A initializer file named `simple_switch.rb` will be added into `config/initializers` after running
install generator. Set feature store strategy to `:yml` and customize the feature configuration yaml
file's name and installation place in this file.

````ruby
  # feature management strategy
  # the supported strategies are: [:yml, :database]
  # default strategy is [:database]
  config.feature_store = :yml

  # configuration for yml strategy
  # feature switch configuration yaml file stored location, by default it is stored
  # under config directory
  config.feature_config_file_dir  = 'config'

  # configuration for yml strategy
  # feature switch configuration yaml file name, by default it is 'feature_config.yml'
  config.feature_config_file_name = 'feature_config.yml'
````
Then run the following commands to copy feature configuration yaml file to the target directory.

Run install generator:

    $ rails generate simple_switch:install

Now you are ready to define features:
````yml
foo:
  description: Foo Feature
  states:
    development: true
    test: true
    production: false
bar:
  description: Bar Feature
  states:
    development: true
    test: true
    production: true
````
Now you can use it in models like this:

````ruby
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
````
In controllers like this:

````ruby
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
````
And in views like this:

````erb
<% if feature_on?(:foo) %>
  <p>Experiment foo is on</p>
<% end %>

<% if feature_off?(:bar) %>
  <p>Experiment bar is off</p>
<% end %>
````

### Database Strategy
Store and manage features and configurations in database.

Run initialize generator:

    $ rails generate simple_switch:initialize

A initializer file named `simple_switch.rb` will be added into `config/initializers` after running
install generator. Set feature store strategy to `:database` and leave configuration for yaml strategy
commented out.

````ruby
  # feature management strategy
  # the supported strategies are: [:yml, :database]
  # default strategy is [:database]
  config.feature_store = :database

  # configuration for yml strategy
  # feature switch configuration yaml file stored location, by default it is stored
  # under config directory
  # config.feature_config_file_dir  = 'config'

  # configuration for yml strategy
  # feature switch configuration yaml file name, by default it is 'feature_config.yml'
  # config.feature_config_file_name = 'feature_config.yml'
````
Then run the following commands to copy required migration files to root application and migrate the database.

Run install generator:

    $ rails generate simple_switch:install
    $ bundle exec rake db:migrate

The data structure for `simple_switch` is described as followed:

![ERR Diagram](/images/err_diagram.png)

The following rake tasks are created to generate data for features, environments and configurations. You can also
add data through rails console.

    $ bundle exec rake simple_switch:add_feature name='Foo' description='Foo feature'
    $ bundle exec rake simple_switch:add_environment name='test'
    $ bundle exec rake simple_switch:add_feature_config feature='foo' environment='test' status=true

Now you can use it in models like this:

````ruby
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
````
In controllers like this:

````ruby
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
````
And in views like this:

````erb
<% if feature_on?(:foo) %>
  <p>Experiment foo is on</p>
<% end %>

<% if feature_off?(:bar) %>
  <p>Experiment bar is off</p>
<% end %>
````

### Toggle Features

The following methods are only accessible in controllers:

`feature_config_info` return a hash represents the current feature configuration condition.

`turn_on(feature, env)` turn on a feature on an indicated environment.
````ruby
turn_on(:foo, :development)
````
`turn_off(feature, env)` turn off a feature on an indicated environment.
````ruby
turn_off(:foo, :development)
````

The following rake tasks are created to toggle features for database strategy only, and feature
name and environment name are required:

    $ bundle exec rake simple_switch:turn_on feature='foo' environment='test'
    $ bundle exec rake simple_switch:turn_off feature='foo' environment='test'