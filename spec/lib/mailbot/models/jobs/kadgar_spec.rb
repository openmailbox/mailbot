require 'spec_helper'

RSpec.describe Mailbot::Models::Kadgar do
  around(:each) do |example|
    VCR.use_cassette('twitch/web_api') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42, details: {twitch_users: ['open_mailbox', 'theceo_', 'captainredwolf']} }
end
