require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshLurkLists do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }

  after(:each) { Mailbot::Models::LurkList.destroy_all }

  subject(:job) { described_class.new(frequency: 42) }

  it 'creates lurk lists' do
    expect {
      job.perform
    }.to change { Mailbot::Models::LurkList.count }.by(2)
  end

  it 'removes lurk lists'
end
