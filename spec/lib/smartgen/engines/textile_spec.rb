require 'spec_helper'

describe Smartgen::Engine::Textile do
  def body
    "h1. Some Header\n\nSome paragraph"
  end
  
  def contents
    "<h1>Some Header</h1>\n<p>Some paragraph</p>"
  end
  
  it "should process body using RedCloth" do
    subject.process(body).should == contents
  end
  
  it "should support .textile extension" do
    should be_supported('.textile')
  end
end