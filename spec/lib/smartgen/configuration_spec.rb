require 'spec_helper'

describe Smartgen::Configuration do
  matcher :be_an_empty_array do
    match { |actual| actual.instance_of?(Array) && actual.empty? }
  end
  
  describe "defaults" do
    it "should initialize src_files to an empty array" do
      subject.src_files.should be_an_empty_array
      subject.src_files.should be_empty
    end
    
    it "should initialize output folder to nil" do
      subject.output_folder.should be_nil
    end
    
    it "should initialize layout to nil" do
      subject.layout.should be_nil
    end
    
    it "should initialize assets to an empty array" do
      subject.assets.should be_an_empty_array
    end
    
    it "should initialize metadata_file to nil" do
      subject.metadata_file.should be_nil
    end
    
    it "should initialize use_indexer to false" do
      subject.use_indexer.should be_false
    end

    it "should initialize numbered_index to false" do
      subject.numbered_index.should be_false
    end
  end
end