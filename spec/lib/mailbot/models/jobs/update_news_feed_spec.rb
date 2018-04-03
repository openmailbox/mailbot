require 'spec_helper'

RSpec.describe Mailbot::Models::UpdateNewsFeed do
  it_behaves_like 'a scheduled job', { details: {} }

  let!(:feed) { Mailbot::Models::NewsFeed.create!(reader_class: 'RssReaderMock') }

  subject!(:update) { described_class.create!(details: {news_feed_id: feed.id, discord_channel_id: 42}) }

  after(:each) do
    Mailbot::Models::RssItem.destroy_all
  end

  let(:discord) { DiscordMock.new }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:discord).and_return(discord)
  end

  describe 'updating the feed' do
    context 'when the stories do not yet exist' do
      it 'saves the stories' do
        expect(feed.rss_items.count).to eq(0)

        update.perform

        expect(feed.rss_items.count).to eq(2) # taken from RssReaderMock
      end

      it 'posts to discord' do
        update.perform

        expect(discord.buffer.length).to eq(2)
      end
    end

    context 'when the stories already exist' do
      before(:each) do
        Mailbot::Models::RssItem.create!(guid: 2, news_feed_id: feed.id)
        Mailbot::Models::RssItem.create!(guid: 1, news_feed_id: feed.id)
      end

      it 'does NOT save the stories' do
        expect(feed.rss_items.count).to eq(2)

        update.perform

        expect(feed.rss_items.count).to eq(2)
      end

      it 'does NOT post to Discord' do
        update.perform

        expect(discord.buffer.length).to eq(0)
      end
    end
  end
end
