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
    
    it "should always force generation of each file, even if it exists" do
      FileUtils.mkdir_p(output_folder)
      File.open(output_folder_file("index.html"), 'w') { |f| f.write('old contents') }
      capture(:stdout) { subject.invoke_all }
      read_output("index.html").should == read_fixture("expectations/common/index.html")
    end
    
    context "with nil layout" do
      def options
        { :layout => nil }
      end
    
      it "should not use layout" do
        capture(:stdout) { subject.invoke_all }
        actual_src_filenames.each do |src_filename, src_ext|
          read_output("#{src_filename}.html").should == read_fixture("expectations/common/#{src_filename}.html")
        end
      end
    end
    
    describe "inexistent file" do
      def src_files
        [fixture('src/common/inexistent_file.textile')]
      end

      it "should not generate html" do
        capture(:stdout) { subject.invoke_all }
        File.should_not be_file(output_folder_file("inexistent_file.html"))
      end
    end

    describe "with ERB files" do
      def src_files
        [fixture('src/erb/index.html.erb')]
      end

      it "should generate index file" do
        capture(:stdout) { subject.invoke_all }
        read_output("index.html").should == read_fixture("expectations/erb/index.html")
      end

      describe "with layout" do
        def src_files
          [fixture('src/erb/with_layout/index.html.erb')]
        end

        def options
          { :layout => fixture('src/layout.html.erb') }
        end

        it "should use the layout when generating" do
          capture(:stdout) { subject.invoke_all }
          read_output("index.html").should == read_fixture("expectations/erb/with_layout/index.html")
        end

        context "inside the src_files pattern" do
          def src_files
            [fixture('src/erb/with_layout/**/*')]
          end

          def options
            { :layout => fixture('src/erb/with_layout/layout.html.erb') }
          end

          it "should use the layout when generating" do
            capture(:stdout) { subject.invoke_all }
            read_output("index.html").should == read_fixture("expectations/erb/with_layout/index.html")
          end

          it "should not attempt to render layout using ERB engine" do
            capture(:stdout) { subject.invoke_all }
            read_output("index.html").should == read_fixture("expectations/erb/with_layout/index.html")
          end
        end
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
      
      describe "and metadata" do
        def options
          { :layout => fixture('src/layout_with_metadata.html.erb'), :metadata_file => fixture('src/metadata.yml') }
        end
        
        it "should load metadata from file and expose it when rendering files" do
          capture(:stdout) { subject.invoke_all }
          read_output("index.html").should == read_fixture("expectations/with_layout/index_with_metadata.html")
        end
        
        describe "using conventions" do
          def src_files
            [fixture('src/with_layout/index_with_specific_metadata.textile')]
          end

          def options
            { :layout => fixture('src/layout_with_specific_metadata.html.erb'), :metadata_file => fixture('src/metadata.yml') }
          end
          
          it "should expose metadata for current page data for each file in metadata.current_page" do
            capture(:stdout) { subject.invoke_all }
            read_output("index_with_specific_metadata.html").should == read_fixture("expectations/with_layout/index_with_specific_metadata.html")
          end
        end
      end
    end
    
    describe "assets" do
      def assets
        [fixture("src/assets/images"), fixture("src/assets/javascripts"), fixture("src/assets/stylesheets")]
      end
      
      def options
        { :assets => assets }
      end
      
      it "should copy directories to output folder" do
        capture(:stdout) { subject.invoke_all }

        File.should be_directory(output_folder_file('images'))
        File.should be_directory(output_folder_file('javascripts'))
      end
      
      it "should copy the contents of the given directories to output folder" do
        capture(:stdout) { subject.invoke_all }

        File.should be_file(output_folder_file('images/image.gif'))
        File.should be_file(output_folder_file('javascripts/somelib.js'))
        File.should be_file(output_folder_file('stylesheets/style.css'))
      end

      it "should force copy of the contents of the given directories to output folder" do
        FileUtils.mkdir_p(output_folder_file('javascripts'))
        File.open(output_folder_file('javascripts/somelib.js'), 'w') { |f| f.write('//some code') }

        capture(:stdout) { subject.invoke_all }
        read_output('javascripts/somelib.js').should == read_fixture('src/assets/javascripts/somelib.js')
      end
    end
    
    describe "with indexer" do
      def src_files
        [fixture('src/indexer/index_with_indexer.textile')]
      end
      
      def options
        { :use_indexer => true }
      end
      
      it "should add IDs to each <h> tag" do
        capture(:stdout) { subject.invoke_all }

        actual_src_filenames.each do |src_filename, src_ext|
          read_output("#{src_filename}.html").should == read_fixture("expectations/indexer/#{src_filename}.html")
        end
      end
      
      context "and numbered_index" do
        def src_files
          [fixture('src/indexer/index_with_indexer_and_numbered_index.textile')]
        end
        
        def options
          { :use_indexer => true, :numbered_index => true }
        end

        it "should add numbered indexes on each <h> tag" do
          capture(:stdout) { subject.invoke_all }
          
          actual_src_filenames.each do |src_filename, src_ext|
            read_output("#{src_filename}.html").should == read_fixture("expectations/indexer/#{src_filename}.html")
          end
        end
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
      Smartgen::Generator.renderer.render('some_layout', double(Smartgen::MarkupFile)).should == "do some rendering stuff"
    end
  end
end
