require 'spec_helper'

RSpec.describe Mailbot::Models::News do
  around(:each) do |example|
    VCR.use_cassette('rss/steam') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { details: {} }

  let(:discord) { DiscordMock.new }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:discord).and_return(discord)
  end

  describe 'sending news items to Discord' do
    let(:last_run) { DateTime.new(2018, 3, 25) }

    subject(:job) { described_class.new(details: {}, last_run_at: last_run) }

    it 'posts new stories' do
      job.perform

      expect(discord.buffer.length).to eq(3) # taken from rss/steam fixture
    end
  end
end
