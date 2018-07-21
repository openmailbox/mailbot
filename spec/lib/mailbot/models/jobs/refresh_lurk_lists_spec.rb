require 'spec_helper'

RSpec.describe Mailbot::Models::RefreshLurkLists do
  around(:each) do |example|
    VCR.use_cassette('mailbot_rails') do
      example.run
    end
  end

  it_behaves_like 'a scheduled job', { frequency: 42 }
end
