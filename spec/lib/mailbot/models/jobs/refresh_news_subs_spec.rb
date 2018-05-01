require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshNewsSubs do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }

  subject(:job) { described_class.new }

  it 'fetches news feed subscriptions' do
    expect(job.fetch_subs.length).to eq(2)
  end
end
