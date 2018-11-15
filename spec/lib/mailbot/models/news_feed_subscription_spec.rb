require 'spec_helper'

RSpec.describe Mailbot::Models::NewsFeedSubscription do
  let(:reader)  { Mailbot::RSS::RssReaderMock }
  let(:discord) { Mailbot::Discord::Connection.new }

  let!(:feed) { Mailbot::Models::NewsFeed.create!(reader_class: reader.to_s) }
  let!(:item) { Mailbot::Models::RssItem.create!(news_feed_id: feed.id) }

  subject!(:subscription) { described_class.create!(discord_channel_id: 42, news_feed: feed) }

  before(:each) do
    allow(Mailbot).to receive_message_chain(:instance, :discord).and_return(discord)
  end

  after(:each) { Mailbot::Models::RssItem.destroy_all }

  describe 'notifying Discord' do
    it 'sends the message' do
      expect(discord).to receive(:send_message).once
      subscription.notify_discord(item)
    end

    context 'when the subscription is not enabled' do
      subject!(:subscription) { described_class.create!(discord_channel_id: 42, news_feed: feed, enabled: false) }

      it 'does not send the message' do
        expect(discord).not_to receive(:send_message)
        subscription.notify_discord(item)
      end
    end

    context 'when the channel did not exist or had insufficient permissions' do
      before do
        allow(discord).to receive(:send_message).and_raise(RestClient::NotFound)
      end

      it 'disables the subscription' do
        expect {
          subscription.notify_discord(item)
        }.to change(subscription, :enabled).to(false)
      end
      
      it 'notifies the web API' do
        expect_any_instance_of(Mailbot::WebClient).to receive(:update_news_feed_subscription)
        subscription.notify_discord(item)
      end
    end
  end
end
