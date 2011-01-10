require 'spec_helper'
require 'fileutils'

describe Smartgen::Resource do
  describe "configuration" do
    it "should yield a configuration when configuring" do
      subject.configure do |config|
        config.should be_an_instance_of(Smartgen::Configuration)
      end
    end
    
    it "should use the same configuration on later accesses" do
      configuration = nil
      subject.configure { |config| configuration = config }
      
      subject.configure do |config|
        config.should be_equal(configuration)
      end
    end
  end
end