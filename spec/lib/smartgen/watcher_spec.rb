require 'spec_helper'

describe Smartgen::Watcher do
  it "should create a resource and yield its configuration" do
    expected_config = nil
    Smartgen::Watcher.new(:my_resource) { |config| expected_config = config }
    expected_config.should == Smartgen[:my_resource].config
  end
  
  context "when it will start watching" do
    def src_files
      ['doc/**/*']
    end
    
    def directory_watcher
      return @directory_watcher if @directory_watcher
      
      @directory_watcher = mock(DirectoryWatcher, :add_observer => 'observer', :interval= => '2')
      @directory_watcher.stub!(:start).and_return(@directory_watcher)
      @directory_watcher.stub!(:join).and_return(@directory_watcher)
      @directory_watcher
    end
    
    before do
      DirectoryWatcher.stub!(:new).and_return(directory_watcher)
    end
    
    subject do
      Smartgen::Watcher.new(:my_resource) do |config|
        config.src_files = src_files
        config.output_folder = 'public/docs'
      end
    end
    
    it "should create a directory watcher, pre loading src_files" do
      DirectoryWatcher.should_receive(:new).with('.', :glob => src_files).and_return(directory_watcher)
      capture(:stdout) { subject.start }
    end
    
    it "should add itself as an observer, with :generate method as the callback" do
      directory_watcher.should_receive(:add_observer).with(subject, :generate)
      capture(:stdout) { subject.start }
    end
    
    it "should start watching" do
      directory_watcher.should_receive(:start)
      directory_watcher.should_receive(:join)
      capture(:stdout) { subject.start }
    end
    
    it "should set interval to 2 seconds" do
      directory_watcher.should_receive(:interval=).with(2)
      capture(:stdout) { subject.start }
    end

    context "when generating" do
      it "should generate files" do
        Smartgen[:my_resource].should_receive(:generate!)
        capture(:stdout) { subject.generate }
      end
    end
    
    context "when user hits ctrl+c" do
      it "should exit gracefully" do
        directory_watcher.should_receive(:stop)
        Kernel.should_receive(:exit).with(0)
        Kernel.should_receive(:trap).with('INT').and_yield
        capture(:stdout) { subject.start }
      end
    end
  end
end
