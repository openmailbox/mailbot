require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshNewsSubs do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  let!(:newegg) do
    Mailbot::Models::NewsFeed.create!(link: 'https://www.newegg.com/Product/RSS.aspx?Submit=RSSDailyDeals&Depa=0',
                                      reader_class: 'Mailbot::RSS::Newegg')
  end

  let!(:humble) do
    Mailbot::Models::NewsFeed.create!(link: 'http://blog.humblebundle.com/rss',
                                      reader_class: 'Mailbot::RSS::HumbleBundle')
  end

  after(:each) { Mailbot::Models::NewsFeed.destroy_all }

  it_behaves_like 'a scheduled job', { frequency: 42 }

  subject(:job) { described_class.new(frequency: 42) }

  it 'creates subscriptions' do
    expect {
      job.perform
    }.to change { Mailbot::Models::NewsFeedSubscription.count }.by(1)
  end

  it 'removes subscriptions' do
    humble.news_feed_subscriptions.create!(guild_id: '224223413449916416', discord_channel_id: '431217242123010053')
    newegg.news_feed_subscriptions.create!(guild_id: '224223413449916416', discord_channel_id: '433102426539556864')

    expect {
      job.perform
    }.to change { Mailbot::Models::NewsFeedSubscription.count }.by(-1)
  end
end
