require 'spec_helper'

RSpec.describe Mailbot::Models::SyncRemovedRecords do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }

  after(:each) { Mailbot::Models::LurkList.destroy_all }

  let!(:existing_list) do
    Mailbot::Models::LurkList.create!(nickname:           'Test List',
                                      discord_channel_id: '1',
                                      guild_id:           '2',
                                      mailbot_rails_id:   1,
                                      twitch_names:       ['open_mailbox', 'someone_else'])
  end

  subject(:job) { described_class.new(frequency: 42) }

  it 'deletes LurkLists that were removed via the web UI' do
    expect {
      job.perform
    }.to change { Mailbot::Models::LurkList.count }.by(-1)
  end
end
