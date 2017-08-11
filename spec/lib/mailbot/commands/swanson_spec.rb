require 'spec_helper'

RSpec.describe Mailbot::Commands::Swanson do
  around(:each) do |example|
    VCR.use_cassette('swanson') do
      example.run
    end
  end

  it_behaves_like 'a mailbot command'
end
