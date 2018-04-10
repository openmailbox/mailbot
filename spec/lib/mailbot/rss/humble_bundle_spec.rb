require 'spec_helper'

RSpec.describe Mailbot::RSS::HumbleBundle do
  around(:each) do |example|
    VCR.use_cassette('rss/humble') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed', 20
end
