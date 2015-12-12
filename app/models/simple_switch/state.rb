module SimpleSwitch
  class State < ActiveRecord::Base
    before_save :set_default_status, if: proc { |s| s.status.nil? }

    belongs_to :feature
    belongs_to :environment

    validates_presence_of :feature_id, :environment_id

    private
    def set_default_status
      status = false;
    end
  end
end
