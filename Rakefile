require 'rspec/core/rake_task'
require 'pry'
require 'yard'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :test

desc 'Run the Marvin test suite (RSpec and Rubocop)'
task test: [:spec, :rubocop]

desc 'Enter a console to interact directly with Marvin'
task :console do
  exec 'bundle exec pry -r ./lib/marvin'
end

YARD::Rake::YardocTask.new

RuboCop::RakeTask.new
