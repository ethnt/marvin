require 'spec_helper'

describe Marvin::Command do
  describe '.parse!' do
    it 'returns the Runner instance' do
      command = Marvin::Command.parse!(ARGV.replace(['-I', 'foobar']))

      expect(command).to be_an_instance_of Marvin::Runner
    end

    it 'takes in a file'
    it 'takes in direct input'
    it 'displays the version number'
    it 'displays the help dialog'
  end
end
