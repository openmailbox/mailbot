require 'socket'

Thread.abort_on_exception = true

puts 'Preparing to connect...'

socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
running = true

puts 'Connected...'

socket.puts("PASS #{ENV['TWITCH_CHAT_TOKEN']}")
socket.puts("NICK open_mailbox")

Thread.start do 
  while (running) do
    ready = IO.select([socket])

    ready[0].each do |s|
      line = s.gets
      puts s.gets
    end
  end
end

while (running) do
  command = gets.chomp

  if command == 'quit'
    running = false
  else
    puts "< #{command}"
    socket.puts(command)
  end
end

puts 'Exited.'
