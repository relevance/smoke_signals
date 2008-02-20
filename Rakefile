require 'rake'
require 'rake/testtask'

desc 'Default: run tests.'
task :default => :test

desc 'Default for CruiseControl'
task :cruise => :test

desc 'Test the relevance_tools plugin.'
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end