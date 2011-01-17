require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "lsl"
  gem.homepage = "http://github.com/mharris717/lsl"
  gem.license = "MIT"
  gem.summary = %Q{little shell language}
  gem.description = %Q{little shell language}
  gem.email = "mharris717@gmail.com"
  gem.authors = ["mharris717"]
  # Include your dependencies below. Runtime dependencies are required when using your gem,
  # and development dependencies are only needed for development (ie running rake tasks, tests, etc)
  #  gem.add_runtime_dependency 'jabber4r', '> 0.1'
  #  gem.add_development_dependency 'rspec', '> 1.2.3'
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "lsl #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :make_readme do

  require 'github/markup'
  require 'mharris_ext'
  
  loop do
    str = GitHub::Markup.render("README.md")
    File.create("README.html",str)
    sleep(0.5)
  end
end

task :make_parsers do
  Dir["lib/lsl/grammars/*.treetop"].each do |f|
    name = File.basename(f).split(".").first
    `tt #{f} -o parsers/#{name}.rb`
  end
end

def gem_hash
  reg = /(.*)\(.*([0-9]\.[0-9]\.[0-9])/
  lines = File.read("Gemfile.lock").split("\n").select { |x| x =~ reg }.map { |x| x.strip }
  res = {}
  gems = lines.map do |ln|
    ln =~ reg
    g, version = $1, $2
    #raise "double #{g}" if res[g]
    res[g] = version
  end
  res
end

def gem_js
  gem_hash.map do |g,v|
    "$('#gem').val('#{g}'); " + 
    "$('#version').val('#{v}'); " + 
    "$('#commit').click()"
  end.join("\n")
end

task :js_gems do
  require 'mharris_ext'
  File.create("gem.js",gem_js)
end

