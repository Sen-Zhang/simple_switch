module RouteHelper
  def self.included(base)
    base.routes { SimpleSwitch::Engine.routes }
  end
end
