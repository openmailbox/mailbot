require 'spec_helper'

class MockContext
  attr_reader :messages

  def initialize
    @messages = []
  end

  def send_string(message)
    @messages << message
  end
end

shared_examples_for 'a mailbot command' do
  let(:context) { MockContext.new }
  let(:user)    { OpenStruct.new(name: 'Tester') }
  let(:args)    { [] }

  subject(:command) { described_class.new(user, args) }

  describe '#execute' do
    it 'sets the context' do
      command.execute(context)

      expect(command.context).to eq(context)
    end

    it 'calls the #perform method' do
      expect(command).to receive(:perform).once
      command.execute(context)
    end
  end
end

class MockCommand < Mailbot::Commands::Base
  def perform
    'Hello World'
  end
end

RSpec.describe Mailbot::Commands::Base do
  let(:context) { MockContext.new }
  let(:user)    { OpenStruct.new(name: 'Tester') }
  let(:args)    { [] }

  subject(:command) { MockCommand.new(user, args) }

  it 'sends the result of #perform back to the calling service' do
    command.execute(context)
    expect(context.messages.last).to eq('Hello World')
  end
end
