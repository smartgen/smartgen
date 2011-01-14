require 'spec_helper'

describe Smartgen::Engine::Markdown do
  def body
    "# Some Header\n\nSome paragraph"
  end
  
  def contents
    "<h1>Some Header</h1>\n\n<p>Some paragraph</p>"
  end
  
  it "should process body using BlueCloth" do
    subject.process(body).should == contents
  end
  
  it "should support .md extension" do
    subject.should be_supported('.md')
  end
  
  it "should support .markdown extension" do
    subject.should be_supported('.markdown')
  end
end