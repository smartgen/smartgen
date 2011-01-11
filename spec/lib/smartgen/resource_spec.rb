require 'spec_helper'

describe Smartgen::Resource do
  describe "configuration" do
    it "should yield a configuration when configuring" do
      subject.configure do |config|
        config.should be_an_instance_of(Smartgen::Configuration)
      end
    end
    
    it "should use the same configuration on later accesses" do
      configuration = nil
      subject.configure { |config| configuration = config }
      
      subject.configure do |config|
        config.should be_equal(configuration)
      end
    end
  end
  
  describe "generating" do
    shared_examples_for "generation with configuration" do
      it "should generate files using the configuration" do
        expected_arguments = [subject.config.src_files, subject.config.output_folder]
        expected_options = {
          :layout => subject.config.layout,
          :assets => subject.config.assets,
          :metadata_file => subject.config.metadata_file
        }
      
        mock_generator = mock(Smartgen::Generator)
        Smartgen::Generator.
                  should_receive(:new).
                  with(expected_arguments, expected_options).
                  and_return(mock_generator)
      
        mock_generator.should_receive(:invoke_all)
        subject.generate!
      end
    end

    context "with default options" do
      it_should_behave_like "generation with configuration"
    end
    
    context "with customized options" do
      before do
        subject.configure do |c|
          c.src_files = ['help/**/*', 'ChangeLog', 'doc_src/**/*']
          c.output_folder = 'public/docs'
          c.layout = 'doc_src/layout.html.erb'
          c.assets = ['doc_src/javascript/*.js', 'doc_src/stylesheets/*.css', 'doc_src/images/*.*']
          c.metadata_file = 'doc_src/metadata.yml'
        end
      end
      
      it_should_behave_like "generation with configuration"
    end
  end
end