require 'spec_helper'

RSpec.describe Mailbot::Twitch::Connection do
  let(:mock_socket) { StringIO.new }

  before(:each) do
    allow(TCPSocket).to receive(:new).and_return(mock_socket)
  end

  it_behaves_like 'a Connection'
end
