require 'spec_helper'

describe Smartgen::ObjectHash do
  it { should be_a_kind_of(HashWithIndifferentAccess) }
  
  it "should be duped as an Smartgen::ObjectHash" do
    subject.dup.should be_an_instance_of(Smartgen::ObjectHash)
  end
  
  it "should respond to all of its keys" do
    subject.merge!({:foo => 'foo', 'bar' => 'bar'})

    subject.keys.each do |key|
      should respond_to(key)
    end
  end
  
  it "should respond to ancestor methods" do
    ancestor = Smartgen::ObjectHash.ancestors.first
    ancestor.instance_methods.each do |method|
      should respond_to(method)
    end
  end
  
  it "should fetch key when calling method with the same name directly" do
    subject.merge!({:foo => 'foo'})
    subject.foo.should == 'foo'
  end
  
  describe "nested hashes" do
    subject { Smartgen::ObjectHash.new({:nested_hash => {:some_key => 'value'}})}
    
    it "should accept calling nested methods" do
      subject.nested_hash.some_key.should == 'value'
    end
  end
  
  describe "nested array with hashes" do
    subject { Smartgen::ObjectHash.new({:array => [{:some_key => 'value'}]})}
    
    it "should accept calling nested methods" do
      subject.array.first.some_key.should == 'value'
    end
  end
  
  describe Hash do
    subject { Hash.new }
    
    it "should return an object hash" do
      subject.with_object_hash.should be_an_instance_of(Smartgen::ObjectHash)
    end
  end
end

