require 'spec_helper'

RSpec.describe Mailbot::WebClient do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  subject(:client) { described_class.new }

  it 'retrieves updated news feed subscriptions' do
    results = client.news_feed_subscriptions

    expect(results.length).to eq(2)
    expect(results.first['enabled']).to be true
    expect(results.first.dig('news_feed', 'id')).to eq(2)
  end
end
