require 'spec_helper'

RSpec.describe Mailbot::RSS::Newegg do
  around(:each) do |example|
    VCR.use_cassette('rss/newegg') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 12

  subject(:feed) { described_class.new }

  it 'retrieves the latest Newegg news stories' do
    feed.refresh!

    latest = feed.items.first

    # taken from the rss/steam fixture
    expect(latest.title).to eq('$369.99 - ASUS ROG Strix Radeon RX 570 O4G Gaming OC Edition GDDR5 DP HDMI DVI VR Ready AMD Graphics Card (ROG-STRIX-RX570-O4G-GAMING)')
    expect(latest.link).to eq('https://www.newegg.com/Product/Product.aspx?Item=N82E16814126189&nm_mc=OTC-RSS&cm_sp=OTC-RSS-_-Desktop%20Graphics%20Cards-_-ASUS-_-N82E16814126189')
    expect(latest.guid).to eq(latest.link)
    expect(latest.published_at.utc).to eq(DateTime.new(2018, 3, 26, 20, 19, 21).utc)
    expect(latest.description).not_to be_blank
  end

  it 'formats embed messages for Discord' do
    feed.refresh!

    item  = feed.items.first
    embed = feed.discord_embed(item)

    expect(embed.title).to eq(item.title)
    expect(embed.url).to eq(item.link)
    expect(embed.color).to eq(16743680)
    expect(embed.fields.length).to eq(4)
    expect(embed.footer.to_hash[:icon_url]).to eq('https://pbs.twimg.com/profile_images/265989396/shell_shocker.png')
    expect(embed.footer.to_hash[:text]).to eq('Newegg')
    expect(embed.image.to_hash[:url]).to eq('//images10.newegg.com/NeweggImage/ProductImageCompressAll125/14-126-189-V07.jpg')
    expect(embed.timestamp).to eq(DateTime.new(2018, 3, 26, 20, 19, 21).utc)
  end

  describe 'embedded Discord fields' do
    before(:each) { feed.refresh! }

    let(:embed) { feed.discord_embed(feed.items.first) }

    it 'has a model number' do
      field = embed.fields[0]

      expect(field.to_hash[:name]).to eq('Model #')
      expect(field.to_hash[:value]).to eq('ROG-STRIX-RX570-O4G')
      expect(field.to_hash[:inline]).to be_falsey
    end

    it 'has an item number' do
      field = embed.fields[1]

      expect(field.to_hash[:name]).to eq('Item #')
      expect(field.to_hash[:value]).to eq('N82E16814126189')
      expect(field.to_hash[:inline]).to be_falsey
    end

    it 'has a cart URL' do
      field = embed.fields[2]

      expect(field.to_hash[:name]).to eq('Buy Now')
      expect(field.to_hash[:value]).to eq('[Add To Cart](https://secure.newegg.com/Shopping/AddToCart.aspx?ItemList=N82E16814126189&Submit=ADD&target=NEWEGGCART&nm_mc=OTC-RSS&cm_sp=OTC-RSS-_-Desktop%20Graphics%20Cards-_-ASUS-_-N82E16814126189)')
      expect(field.to_hash[:inline]).to be true
    end

    it 'has a price' do
      field = embed.fields[3]

      expect(field.to_hash[:name]).to eq('Price')
      expect(field.to_hash[:value]).to eq('$369.99')
      expect(field.to_hash[:inline]).to be true
    end

  end
end
