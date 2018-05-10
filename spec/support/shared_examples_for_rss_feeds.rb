RSpec.shared_examples 'an RSS feed' do |new_story_count|
  subject(:adapter) { described_class.new }

  it 'fetches feed items' do
    expect(adapter.items.length).to eq(0)
    adapter.refresh!
    expect(adapter.items.length).to be > 0
    expect(adapter.items.length).to eq(new_story_count) # based off the VCR fixture data
  end
end
