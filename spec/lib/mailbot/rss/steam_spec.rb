require 'spec_helper'

RSpec.describe Mailbot::RSS::Steam do
  around(:each) do |example|
    VCR.use_cassette('rss/steam') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 20

  subject(:feed) { described_class.new }

  it 'retrieves the latest Steam news stories' do
    feed.refresh!

    latest = feed.items.first

    # taken from the rss/steam fixture
    expect(latest.title).to eq('Daily Deal - X-Morph: Defense, 50% Off')
    expect(latest.link).to eq('http://store.steampowered.com/news/38498/')
    expect(latest.guid).to eq(latest.link)
    expect(latest.published_at.utc).to eq(DateTime.new(2018, 3, 26, 17).utc)
  end

  it 'formats the message' do
    feed.refresh!

    latest    = feed.items.first
    formatted = feed.format_message(latest)

    expect(formatted).to eq("Today's Deal: Save 50% on X-Morph: Defense!*  Look for the deals each day on the front page of Steam.  Or follow us on twitter or Facebook for instant notifications wherever you are!  *Offer ends Wednesday at 10AM Pacific Time  - http://store.steampowered.com/news/38498/")
  end
end
