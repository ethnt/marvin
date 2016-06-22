require 'rspec/core/rake_task'
require 'cucumber/rake/task'
require 'pry'
require 'yard'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec)

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

desc 'Run the Marvin test suite (RSpec and Cucumber)'
task test: [:spec, :features, :rubocop]

desc 'Enter a console to interact directly with Marvin'
task :console do
  exec 'bundle exec pry -r ./lib/marvin'
end

desc 'Run all benchmarks'
task :benchmarks do
  exec 'ruby benchmarks/*.rb'
end

namespace :build do

  desc 'Build the lexer'
  task :lexer do
    exec 'ragel -R ./lib/marvin/lexer.rl'
  end

  desc 'Build the parser'
  task :parser do
    exec 'ruby-ll ./lib/marvin/parser.rll -o ./lib/marvin/parser.rb'
  end

  desc 'Build the lexer and parser'
  task :all do
    exec 'ragel -R ./lib/marvin/lexer.rl && ruby-ll ./lib/marvin/parser.rll -o ./lib/marvin/parser.rb'
  end
end

YARD::Rake::YardocTask.new

RuboCop::RakeTask.new
