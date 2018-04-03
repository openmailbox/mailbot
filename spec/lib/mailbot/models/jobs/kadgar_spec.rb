require 'spec_helper'

RSpec.describe Mailbot::Models::Kadgar do
  around(:each) do |example|
    VCR.use_cassette('twitch/streams') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { details: {twitch_ids: ['133652118']} }
end
