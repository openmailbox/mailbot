require 'spec_helper'

RSpec.describe Mailbot::RSS::Steam do
  around(:each) do |example|
    VCR.use_cassette('rss/steam') do
      example.run
    end
  end

  it_behaves_like 'an RSS feed'
end
