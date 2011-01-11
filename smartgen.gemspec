# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "smartgen/version"

Gem::Specification.new do |s|
  s.name        = "smartgen"
  s.version     = Smartgen::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Vicente Mundim"]
  s.email       = ["vicente.mundim@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A static HTML markup generator}
  s.description = %q{Smartgen generates static HTML files from markup files, using textile or markdown, and ERB to create layout templates}

  s.rubyforge_project = "smartgen"

  s.files         = Dir.glob("lib/**/*") + %w{Gemfile Gemfile.lock Rakefile README.md ChangeLog.md}
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency "thor", ">= 0.14.6"
  
  s.add_development_dependency "rspec", ">= 2.3.0"
end
