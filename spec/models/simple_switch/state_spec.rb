require 'spec_helper'

describe SimpleSwitch::State do
  it { is_expected.to validate_presence_of :feature_id }

  it { is_expected.to validate_presence_of :environment_id }

  it { is_expected.to belong_to :feature }

  it { is_expected.to belong_to :environment }
end
