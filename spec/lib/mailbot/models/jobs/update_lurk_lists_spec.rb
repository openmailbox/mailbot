require 'spec_helper'

RSpec.describe Mailbot::Models::UpdateLurkLists do
  around(:each) do |example|
    VCR.use_cassette('twitch/web_api') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }

  let(:discord) { DiscordMock.new }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:discord).and_return(discord)
  end

  after(:each) { Mailbot::Models::LurkList.destroy_all }

  let!(:lurk_list) do
    Mailbot::Models::LurkList.create!(discord_channel_id: '42',
                                      guild_id:           '43',
                                      mailbot_rails_id:   44,
                                      nickname:           'Test List',
                                      twitch_names:       ['open_mailbox', 'theceo_', 'captainredwolf'])
  end

  subject(:job) { described_class.new(frequency: 42) }

  it 'sends the new Kadgar list to the Discord channel' do
    job.perform
    expect(discord.buffer.length).to eq(1)
    expect(discord.buffer.first[:channel_id]).to eq('42')

    expect(discord.buffer.first[:message]).to eq('http://kadgar.net/live/TheCEO_/CaptainRedWolf')
  end
end
