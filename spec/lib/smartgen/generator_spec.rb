require 'spec_helper'
require 'fileutils'

describe Smartgen::Generator do
  def src_files
    [fixture('src/**/*')]
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
  
  def arguments
    [src_files, output_folder]
  end
  
  def options
    { :metadata_file => fixture('src/metadata.yml'), :layout => fixture('src/layout.html.erb'), :assets => [fixture('src/assets/**/*')] }
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
      actual_src_files.map { |f| File.basename(f, File.extname(f)) }.each do |src_filename|
        File.should be_file(output_folder_file("#{src_filename}.html"))
      end
    end
  end
end