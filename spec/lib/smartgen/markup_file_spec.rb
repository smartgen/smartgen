require 'spec_helper'

describe Smartgen::MarkupFile do
  def path
    fixture('src/common/index.textile')
  end

  subject { Smartgen::MarkupFile.new path }

  describe "engine registration" do
    before do
      Smartgen::MarkupFile.engines.clear
    end
    
    after do
      Smartgen::MarkupFile.engines.clear
    end
    
    it "should register textile engine by default" do
      Smartgen::MarkupFile.engines.one? { |engine| engine.instance_of?(Smartgen::Engine::Textile) }.should be_true, "Textile was not registered as engine"
    end
    
    it "should register markdown engine by default" do
      Smartgen::MarkupFile.engines.one? { |engine| engine.instance_of?(Smartgen::Engine::Markdown) }.should be_true, "Markdown was not registered as engine"
    end
    
    class MyEngine < Smartgen::Engine::Base
      protected
        def parse(body)
          "some processing"
        end
        
        def extensions
          ['.something', '.otherext']
        end
    end
    
    it "should register an engine" do
      Smartgen::MarkupFile.register(MyEngine)
      Smartgen::MarkupFile.engines.one? { |engine| engine.instance_of?(MyEngine) }.should be_true, "MyEngine was not registered as engine"
    end
    
    it "should register the engine with high priority" do
      Smartgen::MarkupFile.register(MyEngine)
      Smartgen::MarkupFile.engines.first.should be_an_instance_of(MyEngine)
    end
  end
  
  describe "attributes" do
    it "should have a file path" do
      subject.path.should == path
    end

    it "should have a filename" do
      subject.filename.should == File.basename(path, File.extname(path))
    end

    it "should have an extension" do
      subject.extension.should == File.extname(path)
    end
  end

  describe "contents" do
    it "should returns its raw contents" do
      subject.raw_contents.should == File.read(path)
    end

    it "should return its contents" do
      subject.contents.should == File.read(fixture('expectations/common/index.html'))
    end
  end

  context "engines usage" do
    context "using default engine" do
      it "should use textile as markup engine when using defaults for files without extension" do
        def path
          fixture('src/common/somefile')
        end

        subject.engine.should be_an_instance_of(Smartgen::Engine::Textile)
      end
      
      it "should use the engine with the highest priority for files without extension" do
        class MyEngine
          def process(body)
            "some processing"
          end
          
          def supported?(extension)
            ['.something'].include?(extension)
          end
        end
        
        def path
          fixture('src/common/somefile')
        end
        
        Smartgen::MarkupFile.register(MyEngine)
        subject.engine.should be_an_instance_of(MyEngine)
        Smartgen::MarkupFile.engines.clear
      end
    end
    
    context "using textile engine" do
      it "should use textile as markup engine" do
        subject.engine.should be_an_instance_of(Smartgen::Engine::Textile)
      end
    end

    context "using markdown template" do
      it "should use textile as markup engine for files with .markdown" do
        def path
          fixture('src/common/other_index.markdown')
        end

        subject.engine.should be_an_instance_of(Smartgen::Engine::Markdown)
      end

      it "should use textile as markup engine for files with .md" do
        def path
          fixture('src/common/another_index.md')
        end

        subject.engine.should be_an_instance_of(Smartgen::Engine::Markdown)
      end
    end
  end
  
  describe "indexer" do
    subject { Smartgen::MarkupFile.new path, :indexer => true }
    
    it "should be accessible when using indexer" do
      subject.indexer.should be_an_instance_of(Smartgen::Indexer)
    end
    
    it "should use indexer" do
      mock_indexer = mock(Smartgen::Indexer, :result => 'result')
      Smartgen::Indexer.should_receive(:new).and_return(mock_indexer)
      subject
    end
    
    it "should return indexer result as contents" do
      mock_indexer = mock(Smartgen::Indexer, :result => 'result')
      Smartgen::Indexer.should_receive(:new).and_return(mock_indexer)
      subject.contents.should == 'result'
    end
  end
end