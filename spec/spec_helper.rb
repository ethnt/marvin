require 'simplecov'
require 'codeclimate-test-reporter'

CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'marvin'

RSpec.configure do |config|
  config.fail_fast = true
end
