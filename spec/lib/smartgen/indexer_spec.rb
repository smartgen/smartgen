require 'spec_helper'

describe Smartgen::Indexer do
  matcher :have_tag do |tag, attributes|
    match do |actual|
      doc = Nokogiri::HTML(actual)
      tags = doc.css(tag.to_s)
      tags.present? && tags.any? do |tag|
        attributes.all? do |attribute, value|
          tag.has_attribute?(attribute.to_s) && tag[attribute.to_s] == value
        end
      end
    end
  end
  
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
  
  subject { Smartgen::Indexer.new html }

  1.upto(6).each do |header_level|
    it "should add IDs for each <h#{header_level}> tag in the result" do
      subject.result.should have_tag("h#{header_level}", :id => "a-h#{header_level}-header")
    end
  end
end
