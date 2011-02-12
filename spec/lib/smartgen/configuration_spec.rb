require 'spec_helper'

describe Smartgen::Configuration do
  it { subject.should be_kind_of(Smartgen::ObjectHash) }
end