source "http://rubygems.org"

gemspec

gem "rake", "0.8.7"

platforms :mri_18 do
  gem "ruby-debug"
end

platforms :mri_19 do
  gem "ruby-debug19" if RUBY_VERSION < "1.9.3"
end
