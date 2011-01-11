require 'spec_helper'

describe Smartgen::MarkupFile do
  def path
    fixture('src/index.textile')
  end
  
  subject { Smartgen::MarkupFile.new path }
  
  it "should have a file path" do
    subject.path.should == path
  end
  
  it "should have a filename" do
    subject.filename.should == File.basename(path, File.extname(path))
  end
  
  it "should have an extension" do
    subject.extension.should == File.extname(path)
  end
  
  it "should use textile as markup engine" do
    subject.engine.should == :textile
  end
  
  it "should use textile as markup engine for files without extension" do
    def path
      fixture('src/somefile')
    end

    subject.engine.should == :textile
  end
  
  context "using markdown template" do
    it "should use textile as markup engine for files with .markdown" do
      def path
        fixture('src/other_index.markdown')
      end
      
      subject.engine.should == :markdown
    end
    
    it "should use textile as markup engine for files with .md" do
      def path
        fixture('src/other_index.md')
      end
      
      subject.engine.should == :markdown
    end
  end
  
  it "should returns its raw contents" do
    subject.raw_contents.should == File.read(path)
  end
end