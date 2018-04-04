require 'spec_helper'

RSpec.describe Mailbot::RSS::Steam do
  around(:each) do |example|
    VCR.use_cassette('rss/steam') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 7

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
end
