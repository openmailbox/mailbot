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

  it 'retrieves updated lurk lists' do
    results = client.lurk_lists

    expect(results.length).to eq(2)
    expect(results.first['nickname']).to eq('Test List')
    expect(results.first['twitch_names'].length).to eq(3)
  end

  it 'retrieves removed records' do
    results = client.removed_records

    expect(results.length).to eq(1)
    expect(results.first['model_type']).to eq('LurkList')
    expect(results.first['model_id']).to eq(1)
  end
end
