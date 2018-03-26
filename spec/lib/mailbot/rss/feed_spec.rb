require 'spec_helper'

RSpec.shared_examples 'an RSS feed' do
  subject(:adapter) { described_class.new }

  it 'fetches feed items' do
    expect(adapter.items.length).to eq(0)
    adapter.refresh!
    expect(adapter.items.length).to be > 0
  end

  it 'returns feed items after the given start time' do
    time1 = DateTime.new
    time2 = DateTime.new(2018, 3, 23)
    time3 = DateTime.now + 1.day

    adapter.refresh!

    expect(adapter.items_since(time1).length).to eq(adapter.items.length)
    expect(adapter.items_since(time2).length).to eq(7) # based off the VCR fixture data
    expect(adapter.items_since(time3).length).to eq(0)
  end
end
