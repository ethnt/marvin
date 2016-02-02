require 'spec_helper'

describe Marvin::Command do
  describe '.parse!' do
    it 'returns the Runner instance' do
      command = Marvin::Command.parse!(ARGV.replace(['-I', 'foobar']))

      expect(command).to be_an_instance_of Marvin::Runner
    end
  end
end
