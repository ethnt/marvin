require 'simplecov'
require 'codeclimate-test-reporter'

SimpleCov.start
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marvin'

RSpec.configure do |config|
  config.fail_fast = true

  original_stderr = $stderr
  original_stdout = $stdout

  # Swallow all logger outputs.
  config.before(:all) do
    $stderr = StringIO.new
    $stdout = StringIO.new

    Marvin.configure do |c|
      c.logger  = Marvin::Logger.new($stdout, $stderr)
      c.verbose = true
    end
  end

  # Restore STDERR and STDOUT after the tests.
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
