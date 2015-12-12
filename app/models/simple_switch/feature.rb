module SimpleSwitch
  class Feature < ActiveRecord::Base
    has_many :states
    has_many :environments, through: :states

    validates :name, presence: true, uniqueness: true
  end
end
