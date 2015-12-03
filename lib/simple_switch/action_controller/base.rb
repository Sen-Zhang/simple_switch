require 'action_controller'

module SimpleSwitch
  class ActionController::Base
    include SimpleSwitch::SharedMethods
    include SimpleSwitch::SharedControllerMethods

    helper_method :feature_on?, :feature_off?
  end
end
