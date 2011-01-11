# -*- encoding: utf-8 -*-
$:.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
require 'rspec'
require 'smartgen'

RSpec.configure do |config|
  def fixture(path)
    File.join(fixtures_dir, path)
  end
  
  def fixtures_dir
    File.expand_path('fixtures', File.dirname(__FILE__))
  end

  def sandbox(path)
    File.join(sandbox_dir, path)
  end
  
  def sandbox_dir
    File.expand_path('sandbox', File.dirname(__FILE__))
  end
  
  def capture(stream)
    begin
      stream = stream.to_s
      eval "$#{stream} = StringIO.new"
      yield
      result = eval("$#{stream}").string
    ensure
      eval("$#{stream} = #{stream.upcase}")
    end

    result
  end
  
  alias silence capture
end
