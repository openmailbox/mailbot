require 'socket'

Thread.abort_on_exception = true

class Twitch
  attr_reader :running, :socket

  def initialize
    @running = false
    @socket  = nil
  end

  def send(message)
    puts "< #{message}"
    socket.puts(message)
  end

  def run
    puts 'Preparing to connect...'

    @socket = TCPSocket.new('irc.chat.twitch.tv', 6667)
    @running = true

    socket.puts("PASS #{ENV['TWITCH_CHAT_TOKEN']}")
    socket.puts("NICK open_mailbox")

    puts 'Connected...'

    Thread.start do
      while (running) do
        ready = IO.select([socket])

        ready[0].each do |s|
          line = s.gets
          puts s.gets
        end
      end
    end
  end

  def stop
    @running = false
  end
end

bot = Twitch.new
bot.run

while (bot.running) do
  command = gets.chomp

  if command == 'quit'
    bot.stop
  else
    bot.send(command)
  end
end

puts 'Exited.'
