# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Smartgen do
  describe "resources" do
    it "should create a resource the first time it is accessed" do
      Smartgen[:foo].should be_an_instance_of(Smartgen::Resource)
    end
    
    it "should use the same resource when it is accessed in the future" do
      Smartgen[:foo].should be_equal(Smartgen[:foo])
    end
    
    it "should create different resource for each given name" do
      Smartgen[:foo].should_not be_equal(Smartgen[:bar])
    end
  end
end
