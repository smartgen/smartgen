require 'spec_helper'

describe Smartgen::Indexer do
  matcher :have_tag do |tag, attributes|
    match do |actual|
      tags = Nokogiri::HTML(actual).css(tag.to_s)
      tags.present? && tags.any? do |tag|
        attributes.all? do |attribute, value|
          tag.has_attribute?(attribute.to_s) && tag[attribute.to_s] == value
        end
      end
    end
  end
  
  matcher :have_tag_with_contents do |tag, content|
    match do |actual|
      tags = Nokogiri::HTML(actual).css(tag.to_s)
      tags.present? && tags.any? do |tag|
        tag.content == content
      end
    end
  end
  
  def html
    "<h1>Some header</h1>"
  end
  
  subject { Smartgen::Indexer.new html }

  describe "addition of IDs" do
    def html
      return <<-HTML
<html>
<body>
  <h1>A h1 header</h1>
  <h2>A h2 header</h2>
  <h3>A h3 header</h3>
  <h4>A h4 header</h4>
  <h5>A h5 header</h5>
  <h6>A h6 header</h6>
</body>
</html>
  HTML
    end
  
    1.upto(6).each do |header_level|
      it "should add IDs for each <h#{header_level}> tag in the result" do
        subject.result.should have_tag("h#{header_level}", :id => "a-h#{header_level}-header")
      end
    end
  end
  
  describe "index" do
    def html
      return <<-HTML
<html>
<body>
  <h1>A h1 header</h1>
  <h2>A h2 header</h2>
  <h3>A h3 header</h3>
  <h3>Some other h3 header</h3>
  <h2>Another h2 header</h2>
  <h5>A h5 header</h5>
  <h2>Yet Another h2 header</h2>
  <h3>Yet Another h3 header</h3>
  <h1>Other h1 header</h1>
</body>
</html>
  HTML
    end
    
    it "should return an index with headers data hierarquically distributed" do
      expected_index = [
        { :text => 'A h1 header', :id => 'a-h1-header', :level => 1, :children => [
          { :text => 'A h2 header', :id => 'a-h2-header', :level => 2, :children => [
            { :text => 'A h3 header', :id => 'a-h3-header', :level => 3, :children => [] },
            { :text => 'Some other h3 header', :id => 'some-other-h3-header', :level => 3, :children => [] }
          ] },
          { :text => 'Another h2 header', :id => 'another-h2-header', :level => 2, :children => [
            { :text => 'A h5 header', :id => 'a-h5-header', :level => 5, :children => [] }
          ] },
          { :text => 'Yet Another h2 header', :id => 'yet-another-h2-header', :level => 2, :children => [
            { :text => 'Yet Another h3 header', :id => 'yet-another-h3-header', :level => 3, :children => [] }
          ] },
        ]},
        { :text => 'Other h1 header', :id => 'other-h1-header', :level => 1, :children => [] }
      ]

      subject.index.should == expected_index
    end
    
    context "when numbered_index options is given" do
      subject { Smartgen::Indexer.new html, :numbered_index => true }
      
      it "should add the numbered index to header contents" do
        subject.result.should have_tag_with_contents("h1", "1 A h1 header")
        subject.result.should have_tag_with_contents("h2", "1.1 A h2 header")
        subject.result.should have_tag_with_contents("h3", "1.1.2 Some other h3 header")
      end
      
      it "should return an index with headers data hierarquically distributed with numbered index" do
        expected_index = [
          { :text => 'A h1 header', :id => 'a-h1-header', :level => 1, :numbered_index => '1', :children => [
            { :text => 'A h2 header', :id => 'a-h2-header', :level => 2, :numbered_index => '1.1', :children => [
              { :text => 'A h3 header', :id => 'a-h3-header', :level => 3, :numbered_index => '1.1.1', :children => [] },
              { :text => 'Some other h3 header', :id => 'some-other-h3-header', :level => 3, :numbered_index => '1.1.2', :children => [] }
            ] },
            { :text => 'Another h2 header', :id => 'another-h2-header', :level => 2, :numbered_index => '1.2', :children => [
              { :text => 'A h5 header', :id => 'a-h5-header', :level => 5, :numbered_index => '1.2.1', :children => [] }
            ] },
            { :text => 'Yet Another h2 header', :id => 'yet-another-h2-header', :level => 2, :numbered_index => '1.3', :children => [
              { :text => 'Yet Another h3 header', :id => 'yet-another-h3-header', :level => 3, :numbered_index => '1.3.1', :children => [] }
            ] },
          ]},
          { :text => 'Other h1 header', :id => 'other-h1-header', :level => 1, :numbered_index => '2', :children => [] }
        ]

        subject.index.should == expected_index
      end
    end
  end
end
