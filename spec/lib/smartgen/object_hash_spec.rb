require 'spec_helper'

describe Smartgen::ObjectHash do
  it { should be_a_kind_of(HashWithIndifferentAccess) }

  it "should be duped as an Smartgen::ObjectHash" do
    subject.dup.should be_an_instance_of(Smartgen::ObjectHash)
  end

  it "should differentiate itself when its inspected" do
    subject.inspect.should == "ObjectHash({})"
  end

  it "should respond to all of its keys" do
    subject.merge!({:foo => 'foo', 'bar' => 'bar'})

    subject.keys.each do |key|
      should respond_to(key)
    end
  end

  it "should respond to all of its keys with setter methods" do
    subject.merge!({:foo => 'foo', 'bar' => 'bar'})

    subject.keys.map { |k| "#{k}=" }.each do |key|
      should respond_to(key)
    end
  end
  
  describe "inexistent key" do
    it "should not respond to" do
      capture(:stderr) { subject.should_not respond_to("invalid_key") }
    end

    it "should return an empty ObjectHash" do
      capture(:stderr) { subject.invalid_key.should be_an_instance_of(Smartgen::ObjectHash) }
    end

    it "should print a warn" do
      capture(:stderr) { subject.invalid_key }.should == "warning: key invalid_key not found on #{subject.inspect}\n"
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

  it "should set a new key when any setter method is called" do
    subject.foo = 'foo'
    subject.foo.should == 'foo'
  end

  it "should update an existing key when setter method is called" do
    subject.merge!({:foo => 'foo'})
    subject.foo = 'bar'
    subject.foo.should == 'bar'
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

