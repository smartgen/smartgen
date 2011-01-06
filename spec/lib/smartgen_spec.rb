# -*- encoding: utf-8 -*-
require 'spec_helper'

describe Smartgen do
  describe "generators" do
    it "should create a generator the first time it is accessed" do
      Smartgen[:foo].should be_an_instance_of(Smartgen::Generator)
    end
    
    it "should use the same generator when it is accessed in the future" do
      Smartgen[:foo].should be_equal(Smartgen[:foo])
    end
    
    it "should create different generator for each given name" do
      Smartgen[:foo].should_not be_equal(Smartgen[:bar])
    end
  end
end
