require 'simplecov'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marvin'

RSpec.configure do |config|
  config.fail_fast = true

  original_stderr = $stderr
  original_stdout = $stdout

  # Swallow all logger outputs.
  config.before(:all) do
    $stderr = File.open(File::NULL, 'w')
    $stdout = File.open(File::NULL, 'w')

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

def test_source
  File.read('./spec/fixtures/test.txt')
end

def bad_test_source
  File.read('./spec/fixtures/test-declaration.txt')
end
