require 'simplecov'

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
  end

  # Restore STDERR and STDOUT after the tests.
  config.after(:all) do
    $stderr = original_stderr
    $stdout = original_stdout
  end
end
