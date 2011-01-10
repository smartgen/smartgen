require 'spec_helper'

describe Smartgen::Configuration do
  describe "defaults" do
    it "should initialize src_files to an empty array" do
      subject.src_files.should be_an_instance_of(Array)
      subject.src_files.should be_empty
    end
    
    it "should initialize output folder to 'tmp'" do
      subject.output_folder.should == 'tmp'
    end
    
    it "should initialize layout to nil" do
      subject.layout.should be_nil
    end
    
    it "should initialize assets to an empty array" do
      subject.assets.should be_an_instance_of(Array)
      subject.assets.should be_empty
    end
    
    it "should initialize metadata_file to 'metadata.yml'" do
      subject.metadata_file.should == 'metadata.yml'
    end
  end
end