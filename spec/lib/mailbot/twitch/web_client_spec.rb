require 'spec_helper'

RSpec.describe Mailbot::Twitch::WebClient do
  around(:each) do |example|
    VCR.use_cassette('twitch/web_api') do
      example.run
    end
  end

  subject(:client) { described_class.new }

  it 'retrieves a list of live streams' do
    user_names = %w{open_mailbox theceo_ captainredwolf}
    results    = client.streams(user_names)

    expect(results['data'].length).to eq(2)
    expect(results['data'].first['title']).to eq('Another perfect day live from the 55th floor.')
  end

  it 'retrieves a list of users' do
    user_names = %w{open_mailbox theceo_ captainredwolf}
    results    = client.users(user_names)

    expect(results['data'].length).to eq(3)
    expect(results['data'].first['display_name']).to eq('open_mailbox')
  end
end
