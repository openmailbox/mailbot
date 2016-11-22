require 'socket'

puts 'Preparing to connect...'

socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
running = true

puts 'Connected...'

socket.puts("PASS #{ENV['TWITCH_CHAT_TOKEN']}")
socket.puts("NICK open_mailbox")

while (running) do
  ready = IO.select([socket])

  ready[0].each do |s|
    line = s.gets
    puts s.gets
  end
end

puts 'Exited.'
