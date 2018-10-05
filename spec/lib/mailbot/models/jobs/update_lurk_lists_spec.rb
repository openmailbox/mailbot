require 'spec_helper'

RSpec.describe Mailbot::Models::UpdateLurkLists do
  around(:each) do |example|
    VCR.use_cassette('twitch/web_api') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }

  let(:discord) { Mailbot::Discord::Connection.new }
  let(:channel) { instance_double('Discordrb::Channel', load_message: nil) }

  before(:each) do
    allow(discord).to receive(:channel).and_return(channel)
    allow(Mailbot).to receive_message_chain(:instance, :discord).and_return(discord)
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
    expect(discord).
      to receive(:send_message).
      with('42', 'http://kadgar.net/live/TheCEO_/CaptainRedWolf').
      and_return(OpenStruct.new).
      once

    job.perform
  end
end
