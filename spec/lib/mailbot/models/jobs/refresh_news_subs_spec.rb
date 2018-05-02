require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshNewsSubs do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  after(:each) { Mailbot::Models::NewsFeedSubscription.destroy_all }

  it_behaves_like 'a scheduled job', { frequency: 42 }

  subject(:job) { described_class.new(frequency: 42) }

  it 'creates subscriptions' do
    expect {
      job.perform
    }.to change { Mailbot::Models::NewsFeedSubscription.count }.by(2)
  end
end
