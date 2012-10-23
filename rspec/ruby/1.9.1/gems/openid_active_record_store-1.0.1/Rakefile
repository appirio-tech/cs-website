#!/usr/bin/env rake
require 'rake/testtask'
require 'rdoc/task'

desc 'Default: run unit tests.'
task :default => :test

desc 'Test the openid_store_active_record plugin.'
Rake::TestTask.new(:test) do |t|
  t.ruby_opts << '-rubygems'
  t.libs += %w[test]
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
  t.warning = true
end

desc 'Generate documentation for the openid_store_active_record plugin.'
RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'OpenidStoreActiveRecord'
  rdoc.options << '--line-numbers' << '--inline-source'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc "build gem"
task :gem do
  sh "gem build openid_active_record_store.gemspec"
end