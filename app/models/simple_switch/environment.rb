module SimpleSwitch
  class Environment < ActiveRecord::Base
    has_many :states, dependent: :destroy
    has_many :features, through: :states

    validates_presence_of :name
  end
end
