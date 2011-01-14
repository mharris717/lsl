source "http://rubygems.org"

def is_windows?
  processor, platform, *rest = RUBY_PLATFORM.split("-")
  platform == 'mswin32' || platform == 'mingw32'
end
  
group :development do
  gem "rspec", "~> 2.1.0"
  gem "bundler", "~> 1.0.0"
  gem "jeweler", "~> 1.5.1"
  gem "rcov", ">= 0"
  
  gem 'github-markup'
  gem 'rdiscount'
end

gem 'andand'
gem "treetop"
gem 'mharris_ext'
gem 'to_parsed_obj'

gem 'win32console' if is_windows?
