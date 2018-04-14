require 'spec_helper'
require_relative './feed_spec'

RSpec.describe Mailbot::RSS::Blizzard do
  around(:each) do |example|
    VCR.use_cassette('rss/blizzard') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 26

  subject(:feed) { described_class.new }

  it 'retrieves the latest Blizzard news stories' do
    feed.refresh!

    latest = feed.items.first

    # taken from the rss/blizzard fixture
    expect(latest.title).to match('A Look at HCT 2018 Season 1')
    expect(latest.guid).to eq('/en-us/hearthstone/21709832/a-look-at-hct-2018-season-1-s-point-leaders')
    expect(latest.link).to eq("https://news.blizzard.com#{latest.guid}")
    expect(latest.published_at.utc).to eq(3.hours.ago.beginning_of_hour.utc)
    expect(latest.description).to eq('With the first point-earning season of the 2018 Hearthstone Championship Tour officially behind us, we now know who the CP pack leaders are.')
  end
end
