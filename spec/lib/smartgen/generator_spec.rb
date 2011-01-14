require 'spec_helper'
require 'fileutils'

describe Smartgen::Generator do
  def src_files
    [fixture('src/common/**/*')]
  end
  
  def output_folder
    sandbox('doc')
  end
  
  def output_folder_file(path)
    File.join(output_folder, path)
  end
  
  def actual_src_files
    Dir[*src_files].select { |f| ['.textile', '.markdown', '.md'].include?(File.extname(f)) }
  end
  
  def actual_src_filenames
    actual_src_files.map { |f| [File.basename(f, File.extname(f)), File.extname(f)] }
  end
  
  def read_output(filename)
    File.read(output_folder_file(filename))
  end
  
  def read_fixture(filename)
    File.read(fixture(filename))
  end
  
  def arguments
    [src_files, output_folder]
  end
  
  def options
    {}
  end
  
  subject { Smartgen::Generator.new arguments, options, { :verbose => false } }
  
  before do
    FileUtils.rm_rf output_folder
  end
  
  describe "generation" do
    it "should create the output folder" do
      capture(:stdout) { subject.invoke_all }
      File.should be_directory(output_folder)
    end
    
    it "should create HTML files for each markup template in src_files" do
      capture(:stdout) { subject.invoke_all }
      actual_src_filenames.each do |src_filename, src_ext|
        File.should be_file(output_folder_file("#{src_filename}.html"))
      end
    end
    
    it "should convert markup files into HTML files when generating" do
      capture(:stdout) { subject.invoke_all }
      actual_src_filenames.each do |src_filename, src_ext|
        read_output("#{src_filename}.html").should == read_fixture("expectations/common/#{src_filename}.html")
      end
    end
    
    describe "with layout" do
      def src_files
        [fixture('src/with_layout/index.textile')]
      end
      
      def options
        { :layout => fixture('src/layout.html.erb') }
      end
      
      it "should use the layout when generating" do
        capture(:stdout) { subject.invoke_all }
        read_output("index.html").should == read_fixture("expectations/with_layout/index.html")
      end
    end
  end
  
  describe "renderer registration" do
    it "should register ERB renderer by default" do
      Smartgen::Generator.renderer.should be_an_instance_of(Smartgen::Renderer::ERB)
    end
    
    it "should allow the registration of a custom renderer" do
      class MyRenderer
        def render(layout, markup_file)
          "do some rendering stuff"
        end
      end
      
      Smartgen::Generator.renderer = MyRenderer.new
      Smartgen::Generator.renderer.render('some_layout', mock(Smartgen::MarkupFile)).should == "do some rendering stuff"
    end
  end
end