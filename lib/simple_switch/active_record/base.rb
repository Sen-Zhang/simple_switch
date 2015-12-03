require 'active_record'

module SimpleSwitch
  class ActiveRecord::Base
    extend SimpleSwitch::SharedMethods
    include SimpleSwitch::SharedMethods
  end
end
