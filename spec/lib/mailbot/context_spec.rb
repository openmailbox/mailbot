require 'spec_helper'

class MockService
  attr_reader :messages

  def initialize
    @messages = []
  end

  def send_message(message, options)
    @messages << message
  end
end

RSpec.describe Mailbot::Context do
  subject(:context) { described_class.new }

  describe '#send_string' do
    it 'has a return value that is the message being sent' do
      expect(context.send_string('Hello World')).to eq('Hello World')
    end

    context 'when the service is not null' do
      it 'sends the message through the service' do
        service         = MockService.new
        context.service = service
        context.send_string('Hello World!')

        expect(service.messages.last).to eq('Hello World!')
      end
    end
  end
end
