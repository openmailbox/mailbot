require 'spec_helper'

RSpec.describe Mailbot::RSS::HumbleBundle do
  around(:each) do |example|
    VCR.use_cassette('rss/humble') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 20

  subject(:feed) { described_class.new }

  it 'retrieves the latest Humble Bundle news stories' do
    feed.refresh!

    latest = feed.items.first

    # taken from the rss/steam fixture
    expect(latest.title).to match(/^The Humble Book Bundle: Game Studies/)
    expect(latest.link).to eq('http://blog.humblebundle.com/post/172765956154')
    expect(latest.guid).to eq(latest.link)
    expect(latest.published_at.utc).to eq(DateTime.new(2018, 4, 9, 18, 41, 58).utc)
  end
end
