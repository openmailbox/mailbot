require 'spec_helper'

RSpec.describe Mailbot::RSS::Newegg do
  around(:each) do |example|
    VCR.use_cassette('rss/newegg') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 12

  subject(:feed) { described_class.new }

  it 'retrieves the latest Steam news stories' do
    feed.refresh!

    latest = feed.items.first

    # taken from the rss/steam fixture
    expect(latest.title).to eq('$369.99 - ASUS ROG Strix Radeon RX 570 O4G Gaming OC Edition GDDR5 DP HDMI DVI VR Ready AMD Graphics Card (ROG-STRIX-RX570-O4G-GAMING)')
    expect(latest.link).to eq('https://www.newegg.com/Product/Product.aspx?Item=N82E16814126189&nm_mc=OTC-RSS&cm_sp=OTC-RSS-_-Desktop%20Graphics%20Cards-_-ASUS-_-N82E16814126189')
    expect(latest.guid).to eq(latest.link)
    expect(latest.published_at.utc).to eq(DateTime.new(2018, 3, 26, 20, 19, 21).utc)
  end

  it 'filters based on keywords' do
    feed.refresh!

    expect(feed.filtered_items_since(DateTime.new).length).to eq(6)
  end
end
