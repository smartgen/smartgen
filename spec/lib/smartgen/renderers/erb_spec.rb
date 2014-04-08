require 'spec_helper'

describe Smartgen::Renderer::ERB do
  def contents
    "<p>Some HTML content</p>"
  end
  
  def markup_file
    @markup_file ||= double(Smartgen::MarkupFile, :contents => contents)
  end
  
  it "should render the given layout with markup_file variable" do
    layout = "<html><body><%= markup_file.contents %></body></html>"
    
    subject.render(layout, markup_file).should == "<html><body>#{contents}</body></html>"
  end
  
  it "should render the given layout without setting metadata, but using methods to access metadata in template" do
    layout = "<html><body><%= markup_file.contents %><div><%= metadata.some_key %></div></body></html>"
    
    capture(:stderr) { subject.render(layout, markup_file).should == "<html><body>#{contents}<div>{}</div></body></html>" }
  end
  
  it "should render the given layout with metadata variable" do
    layout = "<html><body><%= markup_file.contents %><div><%= metadata[:some_key] %></div></body></html>"
    subject.render(layout, markup_file, Smartgen::ObjectHash.new(:some_key => 'some_value')).should == "<html><body>#{contents}<div>some_value</div></body></html>"
  end
  
  it "should render the given layout with metadata variable, using methods instead of accessing keys" do
    layout = "<html><body><%= markup_file.contents %><div><%= metadata.some_key %></div></body></html>"
    subject.render(layout, markup_file, Smartgen::ObjectHash.new(:some_key => 'some_value')).should == "<html><body>#{contents}<div>some_value</div></body></html>"
  end

  it "should render the given layout with metadata variable, using nested methods instead of accessing keys" do
    layout = "<html><body><%= markup_file.contents %><div><%= metadata.nested_hash.some_key %></div></body></html>"
    subject.render(layout, markup_file, Smartgen::ObjectHash.new(:nested_hash => {:some_key => 'some_value'})).should == "<html><body>#{contents}<div>some_value</div></body></html>"
  end
end
