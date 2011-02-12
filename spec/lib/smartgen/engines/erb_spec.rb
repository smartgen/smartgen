require 'spec_helper'

describe Smartgen::Engine::ERB do
  let :body do
    "2 + 2 = <%= 2 * 2 %>"
  end
  
  let :contents do
    "2 + 2 = 4"
  end
  
  it "should process body using ERB" do
    subject.process(body).should == contents
  end
  
  it "should support .erb extension" do
    should be_supported('.erb')
  end
  
  context "with metadata" do
    let :body do
      "Some metadata: <%= metadata.name %>"
    end
    
    let :contents do
      "Some metadata: #{metadata.name}"
    end
    
    let :metadata do
      Smartgen::ObjectHash.new :name => 'Vicente'
    end
    
    it "should process body using ERB" do
      subject.process(body, metadata).should == contents
    end
  end
end