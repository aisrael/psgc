# encoding: utf-8

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
  gem.name = "psgc"
  gem.homepage = "http://github.com/AlistairIsrael/psgc"
  gem.license = "MIT"
  gem.summary = %Q{Philippine Standard Geographic Code}
  gem.description = %Q{A Ruby gem that provides PSGC (Philippine Standard Geographic Code) data.}
  gem.email = "aisrel@gmail.com"
  gem.authors = ["Alistair A. Israel"]

  gem.files             = `git ls-files`.split("\n")
  gem.test_files        = `git ls-files -- {test,spec}/*`.split("\n")
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core/rake_task'
desc 'Run RSpec tests'
RSpec::Core::RakeTask.new(:test) do |test|
  test.verbose = true
end

# TODO Use simplecov
# require 'rcov/rcovtask'
# Rcov::RcovTask.new do |test|
  # test.libs << 'test'
  # test.pattern = 'test/**/test_*.rb'
  # test.verbose = true
  # test.rcov_opts << '--exclude "gems/*"'
# end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "psgc #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

require 'psgc'
require 'psgc/rake_task'
psgc = PSGC::RakeTask.new do |t|
end
