require 'spec_helper'

RSpec.describe Mailbot::Models::Job do
  subject(:job) { described_class.new(frequency: 60) }

  describe '#ready?' do
    it 'is ready when it has never run before' do
      expect(job.ready?).to be true
    end

    it 'is not ready when it just ran' do
      job.last_run_at = 5.seconds.ago

      expect(job.ready?).to be false
    end

    it 'is ready after the stated frequency has elapsed' do
      job.last_run_at = 2.minutes.ago

      expect(job.ready?).to be true
    end
  end
end

RSpec.shared_examples 'a scheduled job' do |attributes|
  subject(:job) { described_class.new(attributes) }

  let(:channel) { instance_double('Discordrb::Channel', load_message: nil) }
  let(:discord) { Mailbot::Discord::Connection.new }

  before(:each) do
    allow(discord).to receive(:channel).and_return(channel)
    allow(discord).to receive(:send_message).and_return(OpenStruct.new)
    allow(Mailbot).to receive_message_chain(:instance, :discord).and_return(discord)
  end

  it 'updates the last_run_at timestamp' do
    time = 10.minutes.ago

    expect(job.last_run_at).to be nil

    Timecop.freeze(time) do
      job.perform
    end

    expect(job.last_run_at).not_to be nil
  end
end
