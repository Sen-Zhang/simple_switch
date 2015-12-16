require 'spec_helper'

describe SimpleSwitch::Environment do
  it { is_expected.to validate_presence_of :name }

  it { is_expected.to validate_uniqueness_of :name }

  it { is_expected.to have_many :states }

  it { is_expected.to have_many :features }
end
