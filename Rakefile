require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'pry'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

desc 'Run the Marvin test suite (RSpec and Cucumber)'
task :test do
  Rake::Task['spec'].invoke
  Rake::Task['features'].invoke
end

desc 'Enter a console to interact directly with Marvin'
task :console do
  Pry.start
end

RuboCop::RakeTask.new
