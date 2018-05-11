RSpec.shared_examples 'a Connection' do
  subject(:connection) { described_class.new }

  it 'creates a background thread' do
    expect(connection.thread).to be nil
    connection.start
    expect(connection.thread).to be_an_instance_of(Thread)
    expect(connection.thread.alive?).to be true
  end

  it 'exits the background thread when stopped' do
    connection.start
    connection.stop
    connection.thread.join
    expect(connection.thread.alive?).to be false
  end
end
