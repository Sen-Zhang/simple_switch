module SimpleSwitch
  class Environment < ActiveRecord::Base
    has_many :states, dependent: :destroy
    has_many :features, through: :states

    validates :name, presence: true, uniqueness: true
  end
end
