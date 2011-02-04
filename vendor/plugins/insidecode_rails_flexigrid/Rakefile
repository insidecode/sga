require 'rubygems'
require 'rake'

PKG_FILES = FileList[
  '[a-zA-Z]*',
  'generators/**/*',
  'lib/**/*',
  'rails/**/*',
  'tasks/**/*',
  'spec/**/*'
]

begin
  require "jeweler"
  
  Jeweler::Tasks.new do |gem|
    gem.name = "insidecode_rails_flexigrid"
    gem.version = "0.0.1"
    gem.author = "Leonardo Marcelino"
    gem.email = "leonardo@insidecode.com.br"
    gem.homepage = "http://insidecode.com.br"
    gem.platform = Gem::Platform::RUBY
    gem.summary = "Rails plugin to allow you to add jQuery Flexigrid into your applications"
    gem.files = PKG_FILES.to_a
    gem.require_path = "lib"
    gem.has_rdoc = false
    gem.extra_rdoc_files = "[README]"
  end
rescue
  puts "Jewler or one of its depencencies is not installed"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = 'spec/**/*_spec.rb'
  test.verbose = true
end

begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |test|
    test.libs << 'spec'
    test.pattern = 'spec/**/*_spec.rb'
    test.verbose = true
  end
rescue LoadError
  task :rcov do
    abort "RCov is not available. In order to run rcov, you must: sudo gem install spicycode-rcov"
  end
end

task :test => :check_dependencies

task :default => :test

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "insidecode_rails_flexigrid #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end