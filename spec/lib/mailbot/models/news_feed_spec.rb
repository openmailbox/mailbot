require 'spec_helper'

RSpec.describe Mailbot::Models::NewsFeed do
  let(:reader)  { Mailbot::RSS::RssReaderMock }
  let(:discord) { DiscordMock.new }

  subject!(:feed) { described_class.create!(reader_class: reader.to_s) }

  before(:each) do
    allow(Mailbot).to receive_message_chain(:instance, :discord, :bot).and_return(discord)
  end

  after(:each) { Mailbot::Models::RssItem.destroy_all }

  describe '#refresh!' do
    context 'when the stories do not yet exist' do
      it 'saves the stories' do
        expect(feed.rss_items.count).to eq(0)

        feed.refresh!

        expect(feed.rss_items.count).to eq(reader.new.refresh!.length)
      end

      context 'when the timestamp is older than the latest recorded story' do
        before(:each) { Mailbot::Models::RssItem.create!(guid: 42, news_feed_id: feed.id, published_at: Time.now + 5.minutes) }

        it 'does NOT save the stories' do
          expect(feed.rss_items.count).to eq(1)

          feed.refresh!

          expect(feed.rss_items.count).to eq(1)
        end
      end
    end

    context 'when the stories already exist' do
      let(:items) { reader.new.refresh! }

      before(:each) do
        items.each do |item|
          Mailbot::Models::RssItem.create!(guid: item.guid, news_feed_id: feed.id)
        end
      end

      it 'does NOT save the stories' do
        expect(feed.rss_items.count).to eq(reader.new.refresh!.length)

        feed.refresh!

        expect(feed.rss_items.count).to eq(reader.new.refresh!.length)
      end
    end
  end
end
